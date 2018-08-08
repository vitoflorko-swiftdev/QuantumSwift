import Foundation

protocol IQubit: class {
    var qubitIndex: Int? { get set }
    func Barrier()
    func CNOT(controlQubit: IQubit)
    func H()
    func Idle()
    func S()
    func Sdg()
    func T()
    func Tdg()
    func U1(lambda: String)
    func U2(phi: String, lambda: String)
    func U3(theta: String, phi: String, lambda: String)
    func X()
    func Y()
    func Z()
}
