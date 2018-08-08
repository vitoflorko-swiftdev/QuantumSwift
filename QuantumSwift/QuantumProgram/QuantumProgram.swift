import Foundation

open class QuantumProgramOption {
    var device: IbmQXDevices
    var shots: Int
    var cache: Bool
    var email: String
    var password: String
    var maxCredits: Int

    public init(device: IbmQXDevices, shots: Int = 1024, cache: Bool = false, email: String, password: String, maxCredits: Int = 5) {
        self.device = device
        self.shots = shots
        self.cache = cache
        self.email = email
        self.password = password
        self.maxCredits = maxCredits
    }
}

open class QuantumProgram {
    private var ibmComputer: IbmQX = IbmQX()
    public var qubits: [Qubit] = []
    var commands: [IQuantumCommand] = []
    var accessToken: String?
    var options: QuantumProgramOption
    var numRetries: Int

    public init(options: QuantumProgramOption, numRetries: Int = 300) {
        self.options = options
        self.numRetries = numRetries
    }

    public func qubitRegistration(qubit: Qubit) {
        qubits.append(qubit)
    }

    public func clear() {
        qubits.removeAll()
    }

    public func execute(completion: ((_ result: IbmQX_SendResult?) -> Void)!) {
        if qubits.count == 0 || commands.count < 1 {
            completion?(nil)
        }
        var qasmCode: String = ""
        var max_qubit_index: Int = 0
        for current_qubit in qubits {
            if max_qubit_index < current_qubit.qubitIndex! {
                max_qubit_index = current_qubit.qubitIndex!
            }
        }
        for command in commands {
            qasmCode += command.toString()
        }
        if qasmCode != "" {
            let tempQasmCode = qasmCode
            max_qubit_index += 1

            //string.Format("include \"qelib1.inc\";qreg q[{0}];creg c[{1}];", max_qubit_index, max_qubit_index) + qasm_code;

            qasmCode = "include \"qelib1.inc\";qreg q[" + String(max_qubit_index) + "];creg c[" + String(max_qubit_index) + "];"
            qasmCode += tempQasmCode
            for current_qubit in qubits {
                qasmCode += "measure q[\(String(describing: current_qubit.qubitIndex!))]->c[\(String(describing: current_qubit.qubitIndex!))];"
            }
        }
        ibmComputer.send(options: IbmQXSendInput(device: options.device,
                                                 shots: options.shots,
                                                 cache: options.cache,
                                                 qasmCode: qasmCode,
                                                 maxCredits: options.maxCredits,
                                                 email: options.email,
                                                 password: options.password,
                                                 numRetries: numRetries)) { (response) in
                                                    completion?(response)
        }
    }

    public func getQubitResultStates(qubitValueResult: IbmQX_SendResult) -> [QubitValueResult] {
        return ibmComputer.getQubitResultStates(qubitValueResult: qubitValueResult.jobMeasurementResult!, usedQubits: qubits)
    }

}
