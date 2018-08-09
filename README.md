# QuantumSwift

A side project together with: https://github.com/spisiak/QuantumCSharp. The project provides a sourcecode that can be built to a vendored framework and used for a real Quantum iOS project

## Usage

The program must be instantiated and the credentials put in. Afterwards you need only to assemble the qubits array (same as the composer on the IBM QX website, and the program must be executed. The codebase can be copied to another workspace or built into a framework and then used in another project.

### Example: Random 0 or 1 generator using the Hadamard gate

```swift
let program: QuantumProgram = QuantumProgram(options: QuantumProgramOption(device: .simulator,
                                                                                   shots: 10,
                                                                                   email: "some.ibm.account@ibm.com",
                                                                                   password: "12345",
                                                                                   maxCredits: 15), numRetries: 50)
                                                     
var qubits: [Qubit] = []
qubits.append(Qubit(program: program, qubitIndex: 0))

qubits[0].H()

program.qubits = qubits
program.execute
{
    (sendResult) in
    if let result = sendResult, result.state == .ok
    {
        let tmp = program.getQubitResultStates(qubitValueResult: result)
        if let zero = tmp[0].zero
        {
            let doubleValue = Double(zero) / 10
            let randomValue = doubleValue < 0.5 ? "0" : "1"
        }
    }
}
```
