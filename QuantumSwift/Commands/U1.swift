import Foundation

public class QU1: IQuantumCommand {
    private var qubitIndex: Int?
    private var lambda: String?

    init() {}

    init(qubitIndex: Int, lambda: String) {
        self.qubitIndex = qubitIndex
        self.lambda = lambda
    }

    func toString() -> String {
        return "u1(\(lambda!)) q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
