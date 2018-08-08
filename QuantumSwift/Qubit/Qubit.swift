import Foundation

public class Qubit: IQubit
{
    var program: QuantumProgram?
    var qubitIndex: Int?

    init(program: QuantumProgram, qubitIndex: Int) {
        self.program = program
        self.qubitIndex = qubitIndex
    }

    func Barrier() {
        if program != nil {
            program?.qubitRegistration(qubit: self)
        }
    }

    func CNOT(controlQubit: IQubit) {
        if program != nil,
            let qubitIndex = qubitIndex,
            let controlQubitIndex = controlQubit.qubitIndex,
            let device = program?.options.device {
            program?.commands.append(ControlledNOT(targetIndex: qubitIndex,
                                                   controlIndex: controlQubitIndex,
                                                   device: device))
        }
    }

    func H() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(Hadamard(qubitIndex: qubitIndex))
        }
    }

    func Idle() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(QIdle(qubitIndex: qubitIndex))
        }
    }

    func S() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(S_PhaseGate(qubitIndex: qubitIndex))
        }
    }

    func Sdg() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(S_PhaseGateT(qubitIndex: qubitIndex))
        }
    }

    func T() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(T_PhaseGate(qubitIndex: qubitIndex))
        }
    }

    func Tdg() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(T_PhaseGateT(qubitIndex: qubitIndex))
        }
    }

    func U1(lambda: String) {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(QU1(qubitIndex: qubitIndex, lambda: lambda))
        }
    }

    func U2(phi: String, lambda: String) {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(QU2(qubitIndex: qubitIndex, phi: phi, lambda: lambda))
        }
    }

    func U3(theta: String, phi: String, lambda: String) {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(QU3(qubitIndex: qubitIndex, theta: theta, phi: phi, lambda: lambda))
        }
    }

    func X() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(PauliX(qubitIndex: qubitIndex))
        }
    }

    func Y() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(PauliY(qubitIndex: qubitIndex))
        }
    }

    func Z() {
        if program != nil, let qubitIndex = qubitIndex {
            program?.commands.append(PauliZ(qubitIndex: qubitIndex))
        }
    }


}
