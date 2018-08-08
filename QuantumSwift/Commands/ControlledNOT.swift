import Foundation

public class ControlledNOT: IQuantumCommand {

    private class EntanglementPair {
        var targetIndex: Int
        var controlIndex: Int

        init(_ targetIndex: Int, _ controlIndex: Int) {
            self.targetIndex = targetIndex
            self.controlIndex = controlIndex
        }
    }

    private var controlIndex: Int?
    private var targetIndex: Int?

    private var ibmqx2: [EntanglementPair] = [EntanglementPair(0,1), EntanglementPair(0, 2), EntanglementPair(1, 2), EntanglementPair(3, 2), EntanglementPair(3, 4), EntanglementPair(4, 2)]
    private var ibmqx4: [EntanglementPair] = [EntanglementPair(1, 0), EntanglementPair(2, 0), EntanglementPair(2, 1), EntanglementPair(2, 4), EntanglementPair(3,2), EntanglementPair(3, 4)]
    private var ibmqx5: [EntanglementPair] = [EntanglementPair(1, 0), EntanglementPair(1, 2), EntanglementPair(2, 3), EntanglementPair(3, 4), EntanglementPair(3, 14), EntanglementPair(5, 4), EntanglementPair(6, 5), EntanglementPair(6, 7), EntanglementPair(6, 11), EntanglementPair(7, 10), EntanglementPair(8, 7), EntanglementPair(9, 8), EntanglementPair(9, 10), EntanglementPair(11, 10), EntanglementPair(12, 11), EntanglementPair(12, 5), EntanglementPair(12, 13), EntanglementPair(13, 4), EntanglementPair(13, 14), EntanglementPair(15,0), EntanglementPair(15, 2), EntanglementPair(15, 14)]

    init() {}

    init(targetIndex: Int, controlIndex: Int, device: IbmQXDevices) {
        if !isValidConfiguration(targetIndex: targetIndex, controlIndex: controlIndex, device: device) {
            fatalError("CX gate between q[\(targetIndex)], q[\(controlIndex)] is not allowed in this topology, CNOT gate error")
        }
        self.targetIndex = targetIndex
        self.controlIndex = controlIndex
    }

    func toString() -> String {
        return "cx q[\(controlIndex!)],q[\(targetIndex!)];"
    }

    private func isValidConfiguration(targetIndex: Int, controlIndex: Int, device: IbmQXDevices) -> Bool {
        var pair: [EntanglementPair] = []
        switch device {
        case .ibmqx2: pair = ibmqx2
        case .ibmqx4: pair = ibmqx4
        case .ibmqx5: pair = ibmqx5
        default: return true
        }
        let item: EntanglementPair? = (pair.filter({ $0.targetIndex == targetIndex && $0.controlIndex == controlIndex })).first
        return item != nil
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        return nil
    }

}
