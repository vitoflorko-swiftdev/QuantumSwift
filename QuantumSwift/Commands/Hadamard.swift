import Foundation

public class Hadamard: IQuantumCommand {
    private var qubitIndex: Int?

    init() {}

    init(qubitIndex: Int) {
        self.qubitIndex = qubitIndex
    }

    func toString() -> String {
        return "h q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
