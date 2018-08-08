import Foundation

public class QU2: IQuantumCommand {
    private var qubitIndex: Int?
    private var phi: String?
    private var lambda: String?

    init() {}

    init(qubitIndex: Int, phi: String, lambda: String) {
        self.qubitIndex = qubitIndex
        self.phi = phi
        self.lambda = lambda
    }

    func toString() -> String {
        return "u2(\(phi!),\(lambda!)) q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
