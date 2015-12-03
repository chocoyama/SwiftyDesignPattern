//: Playground - noun: a place where people can play

import UIKit

/*:
# Bridgeパターン
* 「機能のクラス階層」と「実装のクラス階層」の2つの場所を橋渡しする
* 機能のクラス階層：スーパークラスが基本的な機能を持っていて、サブクラスで新しい機能を追加する
* 実装のクラス階層：スーパークラスが抽象メソッドによってインターフェースを規定、サブクラスは具象メソッドでインターフェースを実装
* 機能を追加したければ、機能のクラス階層を追加。その時に実装のクラス階層をいじる必要はなく、すべての実装で利用することができる。
* ex) OSで分ける処理
* OS共通の部分をImplementorで定義し、OS依存の部分を「実装のクラス階層」で表現する
* -> 「機能のクラス階層」でいくら機能を追加しても、3つのOSを同時に対応していることになる
*/

/*:
## Abstruction
* 「機能のクラス階層」の最上位にあるクラス（抽象的な「何かを表示するもの」クラス）
* Implementorのメソッドを使って基本的な機能だけを記述しているクラス
* Implementorを保持する
*/
class Display {
    private let imp1: DisplayImp1? // 「実装のクラス階層の最上位プロトコル」の実装クラス **2つの階層を橋渡しする** **ここが大事！**
    
    init(imp1: DisplayImp1) { // 「実装」を表すインスタンスを初期化時に渡す
        self.imp1 = imp1
    }
    
    func open() {
        imp1.rawOpen()
    }
    
    func print() {
        imp1.rawPrint()
    }
    
    func close() {
        imp1.rawClose()
    }
    
    /**
     関数の中ではimp1プロパティの実装メソッドを利用しているので、
     DisplayのインターフェースがDisplayImp1のインターフェースに変換されることになる
     */
    final func display() {
        open()
        print()
        close()
    }
}

/*:
## RefinedAbstraction
* 「機能のクラス階層」
* Abstructionに対して機能を追加したもの
* Displayクラスから継承しているメソッドを使って、新しいメソッドを追加している
*/
class CountDisplay: Display {
    init(imp1: DisplayImp1) {
        super.init(imp1: imp1)
    }
    
    func multiDisplay(times: Int) {
        open()
        (0..<times).forEach{ print() }
        close()
    }
}

/*:
## Implementor
* 「実装のクラス階層」の最上位にあるプロトコル
* Abstractionのインターフェースを実装するためのメソッドを規定している
* Displayクラスのopen, print, closeにそれぞれ対応している
*/
protocol DisplayImp1 {
    func rawOpen()
    func rawPrint()
    func rawClose()
}

/*:
## ConcreteImplemenor
* 「実装のクラス階層」
* 具体的にImplementorの実装をするクラス
*/
class StringDisplayImp1: DisplayImp1 {
    private var string = ""
    private var width = 0
    
    init(string: String) {
        self.string = string
        self.width = string.characters.count
    }
    
    func rawOpen() {
        printLine()
    }
    
    func rawPrint() {
        print("|\(string)|")
    }
    
    func rawClose() {
        printLine()
    }
    
    private func printLine() {
        print("+")
        (0..<width).forEach{ print("-") }
        print("+")
    }
}

/*:
##
* 上記4つのクラスを組み合わせて文字列の表示を行う
*/
class Main {
    func exec() {
        let d1 = Display(imp1: StringDisplayImp1(string: "Hello, Japan."))
        let d2 = CountDisplay(imp1: StringDisplayImp1(string: "Hello, World."))
        let d3 = CountDisplay(imp1: StringDisplayImp1(string: "Hello, Universe."))
        d1.display()
        d2.display()
        d3.display()
        d3.multiDisplay(5)
    }
}
