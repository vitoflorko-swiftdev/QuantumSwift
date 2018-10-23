import Foundation
import UIKit

public class IbmQX {
    public var apiUrl: String = "https://quantumexperience.ng.bluemix.net/api/"
    public var apiIsDeviceOnline: [String] = ["Backends/", "/queue/status"]
    public var apiJobs: [String] = ["Jobs?access_token=", "&deviceRunType=", "&fromCache=", "&shots="]
    public var apiUserLogin: String = "users/login"
    public var apiJobResult: [String] = ["Jobs/", "?access_token="]
    public var apiHistoryJobs: String = "Jobs/?access_token={0}"

    private var authenticationData: IbmQX_UserLogin?
    private var storage: Storage = Storage()

    init() {
        authenticationData = storage.loadAuthenticationData()
    }

    public func login(username: String, password: String, completion: ((_ result: Bool?) -> Void)!) {
        let url = apiUrl + apiUserLogin
        let postBody = "email=\(username)&password=\(password)"
        genericRequest(url: url, type: "POST", postData: postBody.data(using: .utf8)) { (response) in
            guard let response = response else { completion?(false); return }
            let decoder = JSONDecoder()
            do {
                let loginData = try decoder.decode(IbmQX_UserLogin.self, from: response)
                let calendar: Calendar = Calendar.current
                loginData.tokenEndTime = self.dateFrom(day: calendar.component(.day, from: Date()) + 9,
                                                       month: calendar.component(.month, from: Date()),
                                                       year: calendar.component(.year, from: Date()),
                                                       hours: calendar.component(.hour, from: Date()),
                                                       minutes: calendar.component(.minute, from: Date()),
                                                       seconds: calendar.component(.second, from: Date()))
                self.authenticationData = loginData
                completion?(self.storage.saveAuthenticationData(data: loginData))
            } catch let jsonError {
                IbmQX.callLogEvent(message: "\(jsonError)")
                completion?(nil)
            }
        }
    }

    public func isDeviceOnline(device: IbmQXDevices, completion: ((_ result: Bool) -> Void)!) {
        if device == .simulator {
            completion(true)
        } else {
            let url = apiUrl + apiIsDeviceOnline[0] + "\(device)" + apiIsDeviceOnline[1]
            genericRequest(url: url, type: "GET") { (response) in
                if let response = response {
                    do {
                        let deviceState = try JSONDecoder().decode(DeviceOnlineState.self, from: response)
                        completion(deviceState.state!)
                    } catch {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }

    public func getJobResult(jobResult: IbmQX_SendResult, options: IbmQXSendInput, completion: ((_ result: IbmQX_SendResult) -> Void)!) {
        guard let job_Result = jobResult.jobResult else { return }
        if let qasms = job_Result.qasms, qasms.count < 1 {
            return
        }
        if let timeInQueue = job_Result.infoQueue?.estimatedTimeInQueue {
            sleep(UInt32(timeInQueue * 1000))
        }
        if let jobResultId = job_Result.id, let authenticationDataId = self.authenticationData?.id {
            let url = self.apiUrl + self.apiJobResult[0] + jobResultId + self.apiJobResult[1] + authenticationDataId
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1

            for _ in 0..<options.numRetries {
                self.genericRequest(url: url, type: "GET", completion: { (response) in
                    guard let response = response else { return }
                    let decoder = JSONDecoder()
                    do {
                        let data: IbmJobMeasurementResult = try decoder.decode(IbmJobMeasurementResult.self, from: response)
                        if let status = data.status, let qasms = data.qasms,
                            status.uppercased() == "COMPLETED" && qasms.count > 0 && qasms[0].status?.uppercased() == "DONE"
                        {
                            jobResult.jobMeasurementResult = data
                            jobResult.results = qasms[0].result?.data?.counts
                            jobResult.state = .ok
                            completion(jobResult)
                            //queue.cancelAllOperations()
                            return
                        }
                    } catch {
                        jobResult.errorMessage = error.localizedDescription
                        jobResult.state = .exception
                        completion(jobResult)
                        //queue.cancelAllOperations()
                        return
                    }
                })
                usleep(1000000)
                if jobResult.state == .ok {
                    return
                }
                //queue.waitUntilAllOperationsAreFinished()
            }
        }
    }

    //TODO: History results from C#
    //public async Task<List<IbmJobMeasurmentResult>> GetHistoryResults(IbmQXSendInput options)

    public func send(options: IbmQXSendInput, completion: ((_ result: IbmQX_SendResult) -> Void)!) {
        let result: IbmQX_SendResult = IbmQX_SendResult()
        IbmQX.callLogEvent(message: "Ibm send function has started ")
        var deviceStatus: Bool = false
        isDeviceOnline(device: options.device!) { (response) in
            deviceStatus = response
            if options.device != .simulator && deviceStatus == false {
                IbmQX.callLogEvent(message: "Target device is currenlty offline")
                result.state = .deviceIsOffline
                completion(result)
            }
            else if let authData = self.authenticationData {
                if let endTime = authData.tokenEndTime, endTime <= Date() {
                    self.getNewAuthentificationData(options: options) { (authResponse) in
                        if let authResponse = authResponse, authResponse == true {
                            self.sendEvent(result: result, options: options, completion: completion)
                        } else {
                            IbmQX.callLogEvent(message: "Process of getting a new authentication token failed")
                            result.state = .authenticationFailed
                            completion(result)
                        }
                    }
                } else {
                    self.sendEvent(result: result, options: options, completion: completion)
                }
            }
            else if self.authenticationData == nil {
                self.getNewAuthentificationData(options: options) { (authResponse) in
                    if let authResponse = authResponse, authResponse == true {
                        self.sendEvent(result: result, options: options, completion: completion)
                    } else {
                        IbmQX.callLogEvent(message: "Process of getting a new authentication token failed")
                        result.state = .authenticationFailed
                        completion(result)
                    }
                }
            }
        }
    }

    private func getNewAuthentificationData(options: IbmQXSendInput, completion: ((_ result: Bool?) -> Void)!) {
        IbmQX.callLogEvent(message: "Getting a new authentificaton token")
        login(username: options.email!, password: options.password!) { (response) in
            completion?(response)
        }
    }

    private func sendEvent(result: IbmQX_SendResult, options: IbmQXSendInput, completion: ((_ result: IbmQX_SendResult) -> Void)!) {
        guard let authenticationData = authenticationData, let authId = authenticationData.id else { return }
        var url = apiUrl + apiJobs[0] + authId + apiJobs[1]
        url += "\(String(describing: options.device!))" + apiJobs[2]
        url += "\(String(describing: options.cache!))".lowercased() + apiJobs[3] + "\(String(describing: options.shots!))"

        let postArray =
            [
                "qasms":
                    [
                        [ "qasm": options.qasmCode ]
                ],
                "shots": String(options.shots!),
                "maxCredits": String(options.maxCredits!),
                "backend": [ "name": String(options.device!.rawValue).lowercased() ]
                ] as [String: AnyObject]

        let postString = postArray.prettyPrint()

        genericRequest(url: url, type: "POST", contentType: "application/json", postData: postString.data(using: .utf8)) { (response) in
            if let response = response {
                let decoder = JSONDecoder()
                do {
                    result.jobResult = try decoder.decode(IbmJobResult.self, from: response)
                    if result.jobResult == nil {
                        result.state = .communicationError
                        completion(result)
                    }
                    IbmQX.callLogEvent(message: "Program is executing")
                    if result.jobResult?.infoQueue != nil {
                        var positionMessage = "Queue position: " + "\(String(describing: result.jobResult?.infoQueue?.position))"
                        positionMessage += ", Estimated time in queue: "
                        positionMessage += "\(String(describing: result.jobResult?.infoQueue?.estimatedTimeInQueue))" + "s"
                        IbmQX.callLogEvent(message: positionMessage)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        IbmQX.callLogEvent(message: "Estimated finish time: " + formatter.string(from: Date()))
                    }
                    self.getJobResult(jobResult: result, options: options, completion: { (result) in
                        completion?(result)
                    })
                } catch {
                    result.errorMessage = error.localizedDescription
                    result.state = .exception
                    completion(result)
                }
            } else {
                result.state = .ibmError
                completion(result)
            }
        }
    }

    public func getQubitResultStates(qubitValueResult: IbmJobMeasurementResult, usedQubits: [Qubit]) -> [QubitValueResult] {
        guard let qasms = qubitValueResult.qasms, let counts = qasms[0].result?.data?.counts else { return [] }
        if qasms.count < 1 && counts.count < 1 {
            return []
        }
        var results: [QubitValueResult] = []
        for i in 0..<usedQubits.count {
            let currentQubit: QubitValueResult = QubitValueResult()
            currentQubit.index = usedQubits[i].qubitIndex
            currentQubit.one = 0
            currentQubit.zero = 0
            for item in counts {
                let inv_key: String = String(item.key.reversed())
                if let index = currentQubit.index, currentQubit.zero != nil && currentQubit.one != nil {
                    if Array(inv_key)[index] == "0" {
                        currentQubit.zero! += item.value
                    } else if Array(inv_key)[index] == "1" {
                        currentQubit.one! += item.value
                    }
                }
                results.append(currentQubit)
            }
        }
        return results
    }

    private func genericRequest(url: String, type: String, contentType: String = "application/x-www-form-urlencoded", postData: Data? = nil, completion: ((_ result: Data?) -> Void)!) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpMethod = type
        if let data = postData {
            request.httpBody = data
        }
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                IbmQX.callLogEvent(message: (error!.localizedDescription))
                completion?(nil)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, httpStatus.statusCode != 204 {
                completion?(nil)
            }
            completion?(data)
        }
        task.resume()
    }

    private func dateFrom(day: Int, month: Int, year: Int,
                          hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: year, month: month, day: day, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(from: components)
    }

    public static func callLogEvent(message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(formatter.string(from: Date()) + ", " + message)
    }

}

extension Dictionary where Key == String, Value == AnyObject {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}
