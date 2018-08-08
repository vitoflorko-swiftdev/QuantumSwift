import Foundation

public class QIdle: IQuantumCommand {
    private var qubitIndex: Int?

    init() {}

    init(qubitIndex: Int) {
        self.qubitIndex = qubitIndex
    }

    func toString() -> String {
        return "id q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
