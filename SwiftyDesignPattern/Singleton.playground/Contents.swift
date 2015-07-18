//: Playground - noun: a place where people can play

import UIKit

/*:
# Singletonパターン
* 指定したクラスのインスタンスが必ず1つしか存在しないことを保証する
*/

/*:
## Singleton
* コンストラクタをprivateにして、外部からの呼び出しを禁ずる
*/
class Singleton {
    static var singleton = Singleton()
    
    private init() {
        print("インスタンスを生成しました")
    }
}

/*:
## Client
*/
class Client: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("start")
        let obj1 = Singleton.singleton
        let obj2 = Singleton.singleton
        if obj1 === obj2 {
            print("same instance")
        } else {
            print("not same instance")
        }
        print("end")
    }
}
