//: Playground - noun: a place where people can play

import UIKit

/*:
# TemplateMethodパターン
*/

/*:
## AbstractClass(AbstractDisplay)
* テンプレートとなるメソッドを定義し、その中で抽象メソッドを実行する処理を記述しておく
* どのように抽象メソッドを呼び出すかだけ書き、実際にどのような処理が行われるかは気にしない
*/

protocol AbstractDisplay {
    func open()
    func prints()
    func close()
    func display() // templateMethod
}

extension AbstractDisplay {
    func display() {
        open()
        for _ in 0..<5 {
            prints()
        }
        close()
    }
}

/*:
## ConcreteClass(CharDisplay)
*　TemplateMethodで呼び出し方を決めておいた抽象メソッドを実装する
*/
class CharDisplay: AbstractDisplay {
    private let ch: Character
    
    init(ch: Character) {
        self.ch = ch
    }
    
    func open() {
        print("<<")
    }
    
    func prints() {
        print(ch)
    }
    
    func close() {
        print(">>")
    }
}

/*:
## ConcreteClass(StringDisplay)
*　TemplateMethodで呼び出し方を決めておいた抽象メソッドを実装する
*/
class StringDisplay: AbstractDisplay {
    private let string: String
    private let width: Int
    
    init(string: String) {
        self.string = string
        self.width = string.utf16.count
    }
    
    func open() {
        printLine()
    }
    
    func prints() {
        print("|\(string)|")
    }
    
    func close() {
        printLine()
    }
    
    func printLine() {
        print("+")
        for _ in 0..<width {
            print("-")
        }
        print("+")
    }
}

/*:
## Client
*/
class Client: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d1 = CharDisplay(ch: "H")
        let d2 = StringDisplay(string: "Hello, world")
        let d3 = StringDisplay(string: "こんにちは。")
        
        d1.display()
        d2.display()
        d3.display()
    }
}
