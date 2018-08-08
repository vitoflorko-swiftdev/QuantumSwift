import Foundation

public class PauliZ: IQuantumCommand {
    private var qubitIndex: Int?

    init() {}

    init(qubitIndex: Int) {
        self.qubitIndex = qubitIndex
    }

    func toString() -> String {
        return "z q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
