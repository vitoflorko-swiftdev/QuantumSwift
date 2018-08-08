import Foundation

public class QU3: IQuantumCommand {
    private var qubitIndex: Int?
    private var theta: String?
    private var phi: String?
    private var lambda: String?

    init() {}

    init(qubitIndex: Int, theta: String, phi: String, lambda: String) {
        self.qubitIndex = qubitIndex
        self.theta = theta
        self.phi = phi
        self.lambda = lambda
    }

    func toString() -> String {
        return "u3(\(theta!),\(phi!),\(lambda!)) q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
