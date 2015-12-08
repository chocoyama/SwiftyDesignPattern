//: Playground - noun: a place where people can play

import UIKit

/*:
# Compositeパターン
* 容器と中身を同一視し、**再帰的**な構造を作る
* ディレクトリの中にはファイルもディレクトリも入れることができる
* このようにあるものを同一種類のものとみなして扱うことで便利になることがある

* LeafとCompositeで共通で使うメソッドをプロトコルで定義する
* 具象クラスでComponentを採用し、CompositeではComponentを配列で持たせる
* LeafとCompositeの操作はプロトコルで定義されたメソッドを使って行う
*/

/*:
# Component
* LeafとCompositeを同一視する
* ディレクトリエントリを表現する
*/
protocol Entry {
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
# Leaf
* 中身（ファイル）を表現する
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
}

/*:
# Composite
* 容器（ディレクトリ）を表現する
*/
class Directory: Entry {
    private var name: String
    private var directory = [Entry]()
    
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
        directory.forEach{size += $0.getSize()}
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
}

/*:
# Client
*/
class Main {
    func exec() {
        print("Making root entries...")
        let rootdir = Directory(name: "root")
        let bindir = Directory(name: "bin")
        let tmpdir = Directory(name: "tmp")
        let userdir = Directory(name: "usr")
        rootdir.add(bindir)
        rootdir.add(tmpdir)
        rootdir.add(userdir)
        bindir.add(File(name: "vi", size: 10000))
        bindir.add(File(name: "latex", size: 20000))
        rootdir.printList()
        
        print("")
        print("Making user entries...")
        let yuki = Directory(name: "yuki")
        let hanako = Directory(name: "hanako")
        let tomura = Directory(name: "tomura")
        userdir.add(yuki)
        userdir.add(hanako)
        userdir.add(tomura)
        yuki.add(File(name: "diary.html", size: 100))
        yuki.add(File(name: "Composite.java", size: 200))
        hanako.add(File(name: "memo.tex", size: 300))
        tomura.add(File(name: "game.doc", size: 400))
        tomura.add(File(name: "junk.mail", size: 500))
        rootdir.printList()
    }
}



