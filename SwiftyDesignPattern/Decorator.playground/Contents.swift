//: Playground - noun: a place where people can play

import UIKit

/*:
# Decoratorパターン
* 中身を変えずに機能追加をすることができる
* 動的な機能追加ができる
* 単純な品揃えでも多様な機能追加ができる
*/

/*:
# Component
* 修飾の土台となるプロトコル
* Decoratorがこのプロトコルを採用するので、関係するクラスは全てこのインターフェースを持つこととなる
*/
protocol Display {
    func getColumns() -> Int
    func getRows() -> Int
    func getRowText(row: Int) -> String?
}

extension Display {
    func show() {
        (0..<getRows()).forEach{
            if let text = getRowText($0) {
                print(text)
            }
        }
    }
}

/*:
# ConcreteComponent
* Componentプロトコルの実装クラス
*/
class StringDisplay: Display {
    private var string = ""
    
    init(string: String) {
        self.string = string
    }
    
    func getColumns() -> Int {
        return string.characters.count
    }
    
    func getRows() -> Int {
        return 1
    }
    
    func getRowText(row: Int) -> String? {
        return (row == 0) ? string : nil
    }
}

/*:
# Decorator
* Compoment役と同じインターフェースを持つ
* initの際にComponentを渡し、保持する
*/
protocol Border: Display {
    var display: Display {get set}
    init(display: Display)
}


/*:
# ConcreteDecorator
* 保持しているComponent or Decoratorへのメッセージが再帰的に呼ばれていく
*/
class SideBorder: Border {
    var display: Display
    private var borderChar = Character.init("")
    
    required init(display: Display) {
        self.display = display
    }
    
    convenience init(display: Display, ch: Character) {
        self.init(display: display)
        self.borderChar = ch
    }
    
    func getColumns() -> Int {
        return 1 + display.getColumns() + 1
    }
    
    func getRows() -> Int {
        return display.getRows()
    }
    
    func getRowText(row: Int) -> String? {
        return "\(borderChar)\(display.getRowText(row))\(borderChar)"
    }
}

/*:
# ConcreteDecorator
* 保持しているComponent or Decoratorへのメッセージが再帰的に呼ばれていく
*/
class FullBorder: Border {
    var display: Display
    
    required init(display: Display) {
        self.display = display
    }
    
    func getColumns() -> Int {
        return 1 + display.getColumns() + 1
    }
    
    func getRows() -> Int {
        return 1 + display.getRows() + 1
    }
    
    func getRowText(row: Int) -> String? {
        if row == 0 || row == display.getRows() + 1 {
            return "+" + makeLine("-", count: display.getColumns()) + "+"
        } else {
            return "|" + (display.getRowText(row - 1) ?? "") + "|"
        }
    }
    
    private func makeLine(ch: Character, count: Int) -> String {
        var line = ""
        (0..<count).forEach{ _ in line.append(ch) }
        return line
    }
}

/*:
# Main
*/
class Main {
    func exec() {
        let b1 = StringDisplay(string: "Hello, world.")
        let b2 = SideBorder(display: b1, ch: "#")
        let b3 = FullBorder(display: b2)
        b1.show()
        b2.show()
        b3.show()
        let b4 = SideBorder(
            display: FullBorder(
                display: FullBorder(
                    display: SideBorder(
                        display: FullBorder(display: StringDisplay(string: "こんにちは")),
                        ch: "*"))),
            ch: "/"
        )
        b4.show()
    }
}
