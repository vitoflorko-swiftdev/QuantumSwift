import UIKit

class ViewController: UIViewController {
    let simpleCommands: Commands = Commands()
    
    override func viewDidLoad() {
        super.viewDidLoad()


//        let word: String = "r"
//        simpleCommands.demonstrate(word: word, indexes: [])

    }

    @IBAction func generate(_ sender: Any) {
        simpleCommands.generate()
    }

}

