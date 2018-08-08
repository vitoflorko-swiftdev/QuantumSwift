import Foundation

public class Barrier: IQuantumCommand {
    private var startIndex: Int?
    private var endIndex: Int?

    init() {}

    init(startQubit: Qubit) {
        if let index = startQubit.qubitIndex {
            startIndex = index
            endIndex = index
        }
    }

    init(startQubit: Qubit, endQubit: Qubit) {
        if let startingIndex = startQubit.qubitIndex, let endingIndex = endQubit.qubitIndex {
            startIndex = startingIndex
            endIndex = endingIndex
        }
    }

    func toString() -> String {
        if startIndex == endIndex {
            return "barries q[\(startIndex!)];"
        } else if let startIndex = startIndex, let endIndex = endIndex {
            var tmp_barrier: String = "barries "
            for i in startIndex..<endIndex {
                tmp_barrier += "q[\(i)];"
            }
            tmp_barrier += "q[\(endIndex)]"
            return tmp_barrier
        }
        return ""
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
