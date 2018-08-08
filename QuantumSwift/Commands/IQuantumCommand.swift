import Foundation

protocol IQuantumCommand: class {
    func toString() -> String
    func parseCommand(rawCommand: String) -> QuantumCommand?
}
