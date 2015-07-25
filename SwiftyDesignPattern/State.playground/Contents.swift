//: Playground - noun: a place where people can play

import UIKit

/*:
# Stateパターン
* Stateパターンでは「状態」をクラスとして表現する
* クラスを切り替えることで状態の変化を表す
*/

/*:
## State
* 出来事に対して呼び出されるメソッドを定義するインターフェース
* 状態依存メソッドの集合
* ここに定義されているメソッドはすべて状態に応じて処理が変化するものである
* 引数としてContextを受け取る
*/
protocol State {
    func doClock(context: Context, hour: Int)
    func doUse(context: Context)
    func doAlerm(context: Context)
    func doPhone(context: Context)
}

/*:
## ConcreteState(DateState)
* Stateの実装クラス
* 状態が変化するたびにインスタンスを作成するのは無駄なのでSingletonにしておく
*/
class DayState: State {
    static var sharedInstance = DayState()
    private init() {}
    
    // 状態の変化が起きるメソッド
    // 対象となるConcreteStateをcontextのメソッドの引数に渡して、状態を切り替える
    func doClock(context: Context, hour: Int) {
        if hour < 0 || 17 <= hour {
            context.changeState(NightState.sharedInstance)
        }
    }
    
    func doUse(context: Context) {
        context.recordLog("金庫使用(昼間)")
    }
    
    func doAlerm(context: Context) {
        context.callSecurityCenter("非常ベル(昼間)")
    }
    
    func doPhone(context: Context) {
        context.callSecurityCenter("通常の通話(昼間)")
    }
    
    func toString() -> String {
        return "[昼間]"
    }
}

/*:
## ConcreteState(NightState)
* Stateの実装クラス
* 状態が変化するたびにインスタンスを作成するのは無駄なのでSingletonにしておく
*/
class NightState: State {
    static var sharedInstance = NightState()
    private init() {}
    
    func doClock(context: Context, hour: Int) {
        if 9 <= hour || hour < 17 {
            context.changeState(DayState.sharedInstance)
        }
    }
    
    func doUse(context: Context) {
        context.callSecurityCenter("非常:夜間の金庫使用！")
    }
    
    func doAlerm(context: Context) {
        context.callSecurityCenter("非常ベル(夜間)")
    }
    
    func doPhone(context: Context) {
        context.recordLog("夜間の通話録音")
    }
    
    func toString() -> String {
        return "[夜間]"
    }
    
    
}


/*:
## Context
* Clientが実装する操作を定義したプロトコル
*/
protocol Context {
    func setClock(hour: Int)
    func changeState(state: State)
    func callSecurityCenter(msg: String)
    func recordLog(msg: String)
}

/*:
## Client
* ConcreteStateを保持する
*/
class Client: UIViewController, Context {
    
    private var textClock = UILabel(frame: CGRectZero)
    private let textScreen = UITextView(frame: CGRectZero)
    private var buttonUse = UIButton(frame: CGRectZero).setTitle("金庫使用", forState: .Normal)
    private var buttonAlerm = UIButton(frame: CGRectZero).setTitle("非常ベル", forState: .Normal)
    private var buttonPhone = UIButton(frame: CGRectZero).setTitle("通常電話", forState: .Normal)
    private var buttonExit = UIButton(frame: CGRectZero).setTitle("終了", forState: .Normal)
    
    private var state = DayState.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func useButtonTapped(sender: UIButton) {
        state.doUse(self)
    }
    
    @IBAction func alermButtonTapped(sender: UIButton) {
        state.doAlerm(self)
    }
    
    @IBAction func phoneButtonTapped(sender: UIButton) {
        state.doPhone(self)
    }
    
    @IBAction func exitButtonTapped(sender: UIButton) {
        // exit
    }
    
    /*
    * 以下はstateオブジェクトのプロトコルで宣言されているメソッドから呼び出される
    */
    
    // このViewControllerを利用する側から呼び出される
    func setClock(hour: Int) {
        var clockstring = "現在時刻は"
        if hour < 10 {
            clockstring += "0\(hour):00"
        } else {
            clockstring += "\(hour):00"
        }
        print(clockstring)
        textClock.text = clockstring
        state.doClock(self, hour: hour)
    }
    
    func changeState(state: State) {
        print("\(self.state)から\(state)へ状態が変化しました")
        self.state = state
    }
    
    func callSecurityCenter(msg: String) {
        textScreen.text += "call! \(msg) \n"
    }
    
    func recordLog(msg: String) {
        textScreen.text += "record ... \(msg) \n"
    }
}



