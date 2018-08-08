import Foundation

public class ProgramParser {
    private var registeredQuantumCommands: [IQuantumCommand] = []

    init() {
        registeredQuantumCommands = [
            Measurement(),
            Barrier(),
            ControlledNOT(),
            QIdle(),
            Hadamard(),
            PauliX(),
            PauliY(),
            PauliZ(),
            S_PhaseGate(),
            S_PhaseGateT(),
            T_PhaseGate(),
            T_PhaseGateT(),
            QU1(),
            QU2(),
            QU3()
        ]
    }

    public func getCommandList(programCode: String) -> [String] {
        return programCode.components(separatedBy: ";")
    }

    private func getCommandType(command: String) -> QuantumCommand? {
        for cmd in registeredQuantumCommands {
            let parsed_cmd = cmd.parseCommand(rawCommand: command)
            if parsed_cmd != nil {
                return parsed_cmd
            }
        }
        return nil
    }

    public func getSyntaxList(commands: [String]) -> [QuantumCommand] {
        var results: [QuantumCommand] = []
        for cmd in commands {
            let parsed_cmd = getCommandType(command: cmd)
            if let parsed_cmd = parsed_cmd {
                results.append(parsed_cmd)
            }
        }
        return results
    }

}
