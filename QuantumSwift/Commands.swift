import Foundation

public class Commands {

    public func demonstrate(word: String, indexes: [Int]) {
        //Metoda pre reverzovanie indexov stringu 'word'
        print("Quantum reverse: word to reverse - " + word)
        print("Loading the quantum request")
        //Volanie metody kvantoveho reverzovania
        quantumReverse(expr: Array(word)) { (result) in
            print("Reversed word: ")
            print(result)
        }
    }

    public func quantumReverse(expr: [Character], completion: ((_ result: String) -> Void)!) {
        var reversed: [Character] = []
        for i in 0..<expr.count {
            quantumReverseIndex(length: expr.count, index: i) { (result) in
                reversed.append(expr[result])
                if reversed.count == expr.count {
                    completion?(String(reversed))
                }
            }
        }
    }

    //PUT IN YOUR IBM QX EMAIL AND PASSWORD: register at https://quantumexperience.ng.bluemix.net

    public func quantumReverseIndex(length: Int, index: Int, completion: ((_ result: Int) -> Void)!) {
        let factor: Double = Double(length) / 10
        let decimatedIndex: Double = Double(index) / factor
        let quantumIndex: Double = decimatedIndex < 5 ? decimatedIndex.rounded(.up) : decimatedIndex.rounded(.down)
        let program: QuantumProgram = QuantumProgram(options: QuantumProgramOption(device: .simulator,
                                                                                   email: "your.email@email.com",
                                                                                   password: "password",
                                                                                   maxCredits: 15))

        var qubits: [Qubit] = []
        qubits.append(Qubit(program: program, qubitIndex: 0))
        qubits.append(Qubit(program: program, qubitIndex: 1))

        qubits[0].U3(theta: "pi * \(String((quantumIndex + 0.5) / 10.0))", phi: "0", lambda: "0")
        qubits[1].U3(theta: "pi * \(String((10.0 - quantumIndex - 0.5) / 10.0))", phi: "0", lambda: "0")

        qubits[0].CNOT(controlQubit: qubits[1])

        program.qubits = qubits
        program.execute { (sendResult) in
            if let result = sendResult, result.state == .ok {
                let tmp = program.getQubitResultStates(qubitValueResult: result)
                if let zero = tmp[0].zero, let one = tmp[0].one {
                    var convertedIndex = Int(Double(9 - (zero / 100)) * factor)
                    convertedIndex = convertedIndex > (length / 2) ? convertedIndex : Int(Double(9 - (one / 100)) * factor)
                }
                completion(Int((9 - decimatedIndex) * factor))
            }
        }
    }

    func generate()
    {
        let program: QuantumProgram = QuantumProgram(options: QuantumProgramOption(device: .simulator,
                                                                                   shots: 10,
                                                                                   email: "vojtech.florko@student.tuke.sk",
                                                                                   password: "aqwsAQWS1324",
                                                                                   maxCredits: 15), numRetries: 1)
        var qubits: [Qubit] = []
        qubits.append(Qubit(program: program, qubitIndex: 0))

        qubits[0].H()

        program.qubits = qubits
        program.execute
        {
            (sendResult) in
            if let result = sendResult, result.state == .ok
            {
                let tmp = program.getQubitResultStates(qubitValueResult: result)
                if let zero = tmp[0].zero//, let one = tmp[0].one
                {
                    let doubleValue = Double(zero) / 10
                    let randomNumText = doubleValue < 0.5 ? "0" : "1"
                    print(randomNumText)
                }
            }
        }
    }
}
