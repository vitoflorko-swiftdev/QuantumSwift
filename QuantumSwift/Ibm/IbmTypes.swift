import Foundation

public class IbmQX_SendResult {
    var state: IbmQXSendState?
    var errorMessage: String?
    var jobResult: IbmJobResult?
    var jobMeasurementResult: IbmJobMeasurementResult?
    var results: [String: Int]?
}

public class IbmQX_UserLogin: Codable {
    var id: String?
    var ttl: Int?
    var created: String?
    var userId: String?
    var tokenEndTime: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case ttl
        case created
        case userId
        case tokenEndTime = "TokenEndTime"
    }
}

public class IbmQXSendInput {
    var device: IbmQXDevices?
    var shots: Int?
    var cache: Bool? = false
    var qasmCode: String = ""
    var maxCredits: Int? = 5
    var email: String?
    var password: String?
    var numRetries: Int = 300
    var secInterval: Int = 1

    init(device: IbmQXDevices?, shots: Int?, cache: Bool? = false, qasmCode: String = "", maxCredits: Int? = 5, email: String?, password: String?, numRetries: Int = 300, secInterval: Int = 1) {
        self.device = device
        self.shots = shots
        self.cache = cache
        self.qasmCode = qasmCode
        self.maxCredits = maxCredits
        self.email = email
        self.password = password
        self.numRetries = numRetries
        self.secInterval = secInterval
    }
}

public class DeviceOnlineState: Codable {
    var state: Bool?
    var busy: Bool?
    var lengthQueue: Int?

    private enum CodingKeys: String, CodingKey {
        case state
        case busy
        case lengthQueue
    }
}

public class IbmQXSendResult {
    var state: IbmQXSendState?
}

public class IbmJobResultBackend: Codable {
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case name
    }
}

public class IbmJobResultQasms: Codable {
    var qasm: String?
    var status: String?
    var executionId: String?

    private enum CodingKeys: String, CodingKey {
        case qasm
        case status
        case executionId
    }
}

public class IbmJobResultQueue: Codable {
    var status: String?
    var position: Int?
    var estimatedTimeInQueue: Int?

    private enum CodingKeys: String, CodingKey {
        case status
        case position
        case estimatedTimeInQueue
    }
}

public class IbmJobResult: Codable {
    var userId: String?
    var id: String?
    var deleted: Bool?
    var creationDate: String?
    var usedCredits: Int?
    var maxCredits: Int?
    var status: String?
    var shots: Int?
    var backend: IbmJobResultBackend?
    var qasms: [IbmJobResultQasms]?
    var infoQueue: IbmJobResultQueue?

    private enum CodingKeys: String, CodingKey {
        case userId
        case id
        case deleted
        case creationDate
        case usedCredits
        case maxCredits
        case status
        case shots
        case backend
        case qasms
        case infoQueue
    }
}

public class MeasurementDateResult: Codable {
    var time: Double?
    var counts: [String: Int]?

    private enum CodingKeys: String, CodingKey {
        case time
        case counts
    }
}

public class MeasurementResult: Codable {
    var date: String?
    var data: MeasurementDateResult?

    private enum CodingKeys: String, CodingKey {
        case date
        case data
    }
}

public class IbmJobMeasurementQasmsResult: Codable {
    var qasm: String?
    var status: String?
    var executionId: String?
    var result: MeasurementResult?

    private enum CodingKeys: String, CodingKey {
        case qasm
        case status
        case executionId
        case result
    }
}

public class IbmJobMeasurementResult: Codable {
    var shots: Int?
    var backend: IbmJobResultBackend?
    var status: String?
    var usedCredits: Int?
    var maxCredits: Int?
    var creationDate: String?
    var deleted: Bool?
    var id: String?
    var userId: String?
    var qasms: [IbmJobMeasurementQasmsResult]?

    private enum CodingKeys: String, CodingKey {
        case shots
        case backend
        case status
        case usedCredits
        case maxCredits
        case creationDate
        case deleted
        case id
        case userId
        case qasms
    }
}

public class IbmErrorCodeMessage {
    var id: Int?
    var message: String?
    var code: String?
}

public class IbmErrorMessage {
    var error: IbmErrorCodeMessage?
}

public class QubitValueResult {
    var index: Int?
    var zero: Int?
    var one: Int?
}
