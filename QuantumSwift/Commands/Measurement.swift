import Foundation

public class Measurement: IQuantumCommand {

    func toString() -> String {
        return ""
    }

    func parseCommand(rawCommand: String) -> QuantumCommand? {
        do {
            let regex = try NSRegularExpression(pattern: "(measure)\\s[a-z]+\\[(\\d+)\\](->)[a-z]+\\[(\\d+)\\]")
            let matches = regex.matches(in: rawCommand, options: [], range: NSRange(location: 0, length: rawCommand.utf16.count))
            if matches.count > 0 && matches.count == 5 {
                let result: QuantumCommand = QuantumCommand()
                result.commandType = self
                result.args = []
                result.args?.append(matches[2].replacementString!)
                result.args?.append(matches[4].replacementString!)
                return result
            }
        } catch {
            return nil
        }
        return nil
    }

}
