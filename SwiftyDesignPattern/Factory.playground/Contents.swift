//: Playground - noun: a place where people can play

import UIKit

/*:
# FactoryMethodパターン
* インスタンスの作成方法をスーパークラスの抽象メソッドで定義する（TemplateMethodパターンを利用）
* 抽象クラスのFactoryでcreateメソッドを実装し、createProductメソッドとregisterProductメソッドを宣言しておく
*/

/*:
## Product
* 「製品」を表現したクラス（プロトコル）。抽象メソッドのuseのみ宣言して、実装はProductのサブクラス（プロトコルを採用したクラス）に任せる
* Factoryが生成するインスタンスが共通で持っているべきメソッドを宣言しておく
*/
protocol Product {
    func use()
}

/*:
## Factory
* TemplateMethodパターンを利用して、Pruductをインスタンス化する
* 抽象メソッドcreateProductで製品を作成
* 抽象メソッドregisterProductで作った製品を登録
* 公開メソッドcreateでcreateProductとregisterProductを実行する
* 抽象メソッドの実装はFactoryのサブクラスで実装する
* Factoryクラスは実際に生成するConcreteProductのことは一切知らなくて良い
*/
protocol Factory {
    func create(owner: String) -> Product
    func createProduct(owner: String) -> Product
    func registerProduct(product: Product)
}

extension Factory {
    func create(owner: String) -> Product {
        let p = createProduct(owner)
        registerProduct(p)
        return p
    }
}

/*:
## ConcreteProduct(IDCard)
*/
class IDCard: Product {
    private var owner: String
    
    init(owner: String) {
        self.owner = owner
    }
    
    func use() {
        print("カードを利用する")
    }
    
    func getOwner() -> String {
        return owner
    }
}

/*:
## ConcreteCreator(IDCardFactory)
*/
class IDCardFactory: Factory {
    private var owners = [String]()
    
    func createProduct(owner: String) -> Product {
        return IDCard(owner: owner)
    }
    
    func registerProduct(product: Product) {
        if let idCard = product as? IDCard {
            owners.append(idCard.getOwner())
        }
    }
    
    func getOwners() -> [String] {
        return owners
    }
}

/*:
## Client
*/
class Client: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let factory = IDCardFactory()
        let card1 = factory.create("takyokoy")
        let card2 = factory.create("yakitori")
        let card3 = factory.create("purin")
        card1.use()
        card2.use()
        card3.use()
    }
}