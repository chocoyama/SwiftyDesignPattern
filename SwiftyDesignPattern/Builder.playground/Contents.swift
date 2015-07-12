//: Playground - noun: a place where people can play

import UIKit
/*: 
# Builderパターン
* Builderプロトコルでメソッドを用意する
* Builderプロトコルを採用したConcreteBuilderが実装を定義
* DirectorクラスがConcreteBuilderを保持し、Builderプロトコルに定義されているメソッドを実行しながらconstructを行う
* 最後にConcreteBuilderの結果を返すメソッドからデータを受け取る
*/

/*:
## Builder
* インスタンスを生成するためのインターフェースを定める
*/
protocol Builder {
    func makeTitle(title: String)
    func makeString(str: String)
    func makeItems(items: [String])
    func close()
}

/*:
## Director
* Builderのプロトコルを使ってインスタンスを生成する
* ConcreteBuilderに依存したプログラミングは行わず、Builderのメソッドのみを使う
*/
class Director {
    let builder: Builder
    
    init (builder: Builder) {
        self.builder = builder
    }
    
    func construct() {
        builder.makeTitle("Greeting")
        builder.makeString("朝から昼にかけて")
        builder.makeItems(["おはようございます。", "こんにちは"])
        builder.makeString("夜に")
        builder.makeItems(["こんばんは", "おやすみなさい", "さようなら"])
        builder.close()
    }
}

/*:
## ConcreteBuilder(TextBuilder)
* Builderのプロトコルを実装するクラス
*/
class TextBuilder: Builder {
    var result = ""
    
    func makeTitle(title: String) {
        result += "-----------"
        result += "【\(title)】"
    }
    
    func makeString(str: String) {
        result += str
    }
    
    func makeItems(items: [String]) {
        for item in items {
            result += "・\(item)"
        }
    }
    
    func close() {
        result += "-----------"
    }
    
    func getResult() -> String {
        return result
    }
}

/*:
## ConcreteBuilder2(HTMLBuilder)
* Builderのプロトコルを実装するクラス
*/
class HTMLBuilder: Builder {
    var result = ""
    
    func makeTitle(title: String) {
        result += "<html><head>"
        result += "<title>\(title)</title>"
        result += "</head><body>"
    }
    
    func makeString(str: String) {
        result += "<p><\(str)/p>"
    }
    
    func makeItems(items: [String]) {
        result += "<ul>"
        for item in items {
            result += "<li>\(item)</li>"
        }
        result += "</ul>"
    }
    
    func close() {
        result += "</body>"
        result += "</html>"
    }
    
    func getResult() -> String {
        return result
    }
}

/*:
## Client
*/
class Controller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textBuilder = TextBuilder()
        let director = Director(builder: textBuilder)
        director.construct()
        let result = textBuilder.getResult()
    }
}



