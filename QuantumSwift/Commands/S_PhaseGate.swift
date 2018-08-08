import Foundation

public class S_PhaseGate: IQuantumCommand {
    private var qubitIndex: Int?

    init() {}

    init(qubitIndex: Int) {
        self.qubitIndex = qubitIndex
    }

    func toString() -> String {
        return "s q[\(qubitIndex!)];"
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
