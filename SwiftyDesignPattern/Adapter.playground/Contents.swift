//: Playground - noun: a place where people can play

import UIKit
/*:
# Adapterパターン
* 「すでに提供されているもの」と「必要なもの」の間のズレを埋めるデザインパターン
* Wrapperパターンとも呼ばれる
* 継承を使ったものと、委譲を使ったもののに種類がある
*
* 必要なものをTargetプロトコルとして宣言しておく
*
* バグのないソースコードを再利用したいときや、古い版と新しい版を共存させたい時などに使える
*/

/*:
## Target(Print)
* 必要なもの
*/
protocol Print {
    func printWeak()
    func printStrong()
}

/*:
## Adapter(PrintBannerInheritance) 【継承を利用した場合】
* 提供されているもの(Adaptee)を **継承** 、必要なもの(Target)を実装する
* Adapteeで実装されているメソッドをTargetで宣言しているメソッド内で呼び出す
* 呼び出し先は継承元のスーパークラスで定義されているメソッド（super.hoge()）
*/
class PrintBannerInheritance: Banner, Print {
    override init(string: String) {
        super.init(string: string)
    }
    
    func printWeak() {
        super.showWithParen()
    }
    
    func printStrong() {
        super.showWithAster()
    }
}

/*:
## Adapter(PrintBannerDelegation) 【委譲を利用した場合】
* 提供されているもの(Adaptee)を **保持** 、必要なもの(Target)を実装する
* Adapteeで実装されているメソッドをTargetで宣言しているメソッド内で呼び出す
* 呼び出し先は保持しているAdapteeクラスのオブジェクト（self.hoge()）
*/
class PrintBannerDelegation: Print {
    private let banner: Banner
    
    init(string: String) {
        self.banner = Banner(string: string)
    }
    
    func printWeak() {
        banner.showWithParen()
    }
    
    func printStrong() {
        banner.showWithAster()
    }
}


/*:
## Adaptee(Banner)
* 提供されているもの
*/
class Banner {
    private var string: String
    
    init(string: String){
        self.string = string
    }
    
    func showWithParen() {
        print("(\(string))")
    }
    
    func showWithAster() {
        print("*\(string)*")
    }
}

/*:
## Client
* クライアントからはPrintBannerクラスがどのように実現されているかを知る必要はない
* Printプロトコルに従っているかどうかのみ気にすれば良い
*/
class Client: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let p: Print = PrintBannerInheritance(string: "Hello")
        p.printWeak()
        p.printStrong()
    }
}



