//: Playground - noun: a place where people can play

import UIKit

/*:
# Prototypeパターン
* クラスからインスタンスを作るのではなく、インスタンスをコピーして新しいインスタンスを作る
1 種類が多すぎてクラスにまとめられない場合
2 クラスからのインスタンス生成が難しい場合（グラフィックエディタでユーザーが描いたインスタンスと同じものなど）
3 フレームワークと生成するインスタンスを分けたい場合
*/

/*:
## Prototype(Product)
* 複製を可能にするもの
* インスタンスをコピーして新しいインスタンスを作るためのメソッドを定める
* cloneメソッドを使って自動的に複製することが可能になる
*/
protocol Product {
    func use(s: String)
    func createClone() -> Product
}

/*:
## Client(Manager)
*/
class Manager {
    private var showcase = [String: Product]() // 「名前」と「インスタンス」の対応関係を保持
    
    func register(name: String, proto: Product) { // 実際のクラスは不明だが、Productプロトコルを採用していることは保証される
        showcase["name"] = proto
    }
    
    func create(protoname: String) -> Product? {
        let p = showcase[protoname]
        return p?.createClone()
    }
}

/*:
## ConcretePrototype(MessageBox)
*
*/
class MessageBox: Product {
    private let decochar: Character
    
    init(decochar: Character) {
        self.decochar = decochar
    }
    
    func use(s: String) {
        let length = s.utf16.count
        for _ in 0..<length+4 {
            print(decochar)
        }
        print("")
        print("\(decochar) \(s) \(decochar)")
        for _ in 0..<length+4 {
            print(decochar)
        }
        print("")
    }
    
    func createClone() -> Product {
        let p = MessageBox(decochar: self.decochar)
        return p
    }
}

/*:
## ConcretePrototype(UnderlinePen)
*
*/
class UnderlinePen: Product {
    private let ulchar: Character
    
    init(ulchar: Character) {
        self.ulchar = ulchar
    }
    
    func use(s: String) {
        let length = s.utf16.count
        print("¥\" \(s) ¥\"")
        print("")
        for _ in 0..<length {
            print(ulchar)
        }
        print("")
    }
    
    func createClone() -> Product {
        let p = UnderlinePen(ulchar: self.ulchar)
        return p
    }
}

/*:
## Controller
*/
class Controller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = Manager()
        let upen = UnderlinePen(ulchar: "~")
        let mbox = MessageBox(decochar: "*")
        let sbox = MessageBox(decochar: "/")
        manager.register("strong message", proto: upen)
        manager.register("warning box", proto: mbox)
        manager.register("slash box", proto: sbox)
        
        let p1 = manager.create("strong message")
        p1?.use("Hello, world.")
        let p2 = manager.create("warning box")
        p2?.use("Hello, world.")
        let p3 = manager.create("slash box")
        p3?.use("Hello, world.")
    }
}


/*:
# おまけ
* SwiftではNSCopyingプロトコルを採用することで自前のPrototypeプロトコルを宣言しなくてもよくなる
* 上の例で言うcreateCloneメソッドの代わりにcopyWithZoneを実装する
*/
class CopyingBox: NSCopying {
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    // NSCopyingプロトコルで定められている必須メソッド
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        let copyingBox = CopyingBox(name: self.name)
        return copyingBox
    }
}
