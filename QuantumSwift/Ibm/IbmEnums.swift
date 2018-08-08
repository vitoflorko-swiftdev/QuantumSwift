import Foundation

public enum IbmQXSendState {
    case deviceIsOffline
    case exception
    case communicationError
    case authenticationFailed
    case measurementTimeout
    case ibmError
    case ok
}

public enum IbmQXDevices: String {
    case simulator
    case ibmqx2
    case ibmqx4
    case ibmqx5
    case qs1_1
}

public enum ibmqx_qasm_simulator {
    case ibmqx_qasm_simulator
    case ibmqx_hpc_qasm_simulator
}
