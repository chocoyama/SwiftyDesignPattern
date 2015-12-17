//: Playground - noun: a place where people can play

import UIKit

/*:
# Visitorパターン
* データ構造と処理を分離する
* データ構造の中を巡り歩く訪問者クラスを用意して、そのクラスが処理を行う
* 新しい処理を追加する場合は、新しい訪問者クラスを用意する
*/

/*:
# Visitor
* ConcreteElementごとの処理を実行するメソッドを用意する
*/
protocol Visitor {
    func visit(file: File)
    func visit(directory: Directory)
}

/*:
# ConcreteVisitor
* visitメソッドの引数で渡されたインスタンスに対する処理を記述する
*/
class ListVisitor: Visitor {
    private var currentDir = ""
    
    func visit(file: File) {
        print("\(currentDir)/\(file)")
    }
    
    func visit(directory: Directory) {
        print("\(currentDir)/\(directory.getName())")
        let saveDir = currentDir
        currentDir = "\(currentDir)/\(directory.getName())"
        directory.directory.forEach { $0.accept(self) }
        currentDir = saveDir
    }
}


/*:
# Element
* 訪問者を受け入れるプロトコル
* このプロトコルを実装しているクラスがVisitorを受け入れる
*/
protocol Element {
    func accept(visitor: Visitor)
}

/*:
# Component
* Compositeパターン + Elementプロトコル
*/
protocol Entry: Element {
    func getName() -> String
    func getSize() -> Int
    func printList(prefix: String)
}
extension Entry {
    func add(entry: Entry) -> Entry {
        fatalError()
    }
    func printList() {
        printList("")
    }
    func toString() -> String {
        return "\(getName())(\(getSize()))"
    }
}

/*:
# ConcreteElement
* Compositeパターン + Elementプロトコルの実装
*/
class File: Entry {
    private var name: String
    private var size: Int
    
    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }
    
    func getName() -> String {
        return name
    }
    
    func getSize() -> Int {
        return size
    }
    
    func printList(prefix: String) {
        print("\(prefix)/\(self)")
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(self)
    }
}

/*:
# ConcreteElement
* Compositeパターン + Elementプロトコルの実装
# ObjectStructure
* Elementの集合を扱う
*/
class Directory: Entry {
    private var name: String
    private(set) var directory = [Entry]()
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func getSize() -> Int {
        var size = 0
        /**
        directoryの中はFile, Directoryどちらの可能性もあるがgetSizeは両方で使える
        Compositeパターンの再帰的構造と同様に、getSizeは再帰的に呼び出されることになる
        */
        directory.forEach{ size += $0.getSize() }
        return size
    }
    
    func add(entry: Entry) -> Entry {
        directory.append(entry)
        return self
    }
    
    func printList(prefix: String) {
        print("\(prefix)/\(self)")
        directory.forEach { (let entry) -> () in
            entry.printList("\(prefix)/\(name)")
        }
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(self)
    }
}

/*:
# Main
*/
class Main {
    func exec() {
        let rootdir = Directory(name: "root")
        let bindir = Directory(name: "bin")
        let tmpdir = Directory(name: "tmp")
        let usrdir = Directory(name: "usr")
        rootdir.add(bindir)
        rootdir.add(tmpdir)
        rootdir.add(usrdir)
        bindir.add(File(name: "vi", size: 10000))
        bindir.add(File(name: "latex", size: 20000))
        rootdir.accept(ListVisitor())
        
        print("")
        print("Maing user entries...")
        let yuki = Directory(name: "yuki")
        let hanako = Directory(name: "hanako")
        let tomura = Directory(name: "tomura")
        usrdir.add(yuki)
        usrdir.add(hanako)
        usrdir.add(tomura)
        yuki.add(File(name: "diary.html", size: 100))
        yuki.add(File(name: "Composite.java", size: 200))
        hanako.add(File(name: "memo.tex", size: 300))
        tomura.add(File(name: "game.doc", size: 400))
        tomura.add(File(name: "junk.mail", size: 500))
        rootdir.accept(ListVisitor())
    }
}
