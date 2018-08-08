import Foundation

public class PauliX: IQuantumCommand {
    private var qubitIndex: Int?

    init() {}

    init(qubitIndex: Int) {
        self.qubitIndex = qubitIndex
    }

    func toString() -> String {
        return "x q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
