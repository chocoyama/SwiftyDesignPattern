//: Playground - noun: a place where people can play

import UIKit

/*:
# Mediatorパターン
* メンバーは一度相談役(Mediator)に状況を伝え、メンバーへの指示は相談役だけが行う
* 多数のオブジェクト間の調整を行わないときに利用すると効果的で、表示のコントロールに関してはMediatorだけが行うようにすることができる
* ex) ログイン時はAのTextFieldを入力不可にしてButtonはアクティブにするが、未ログイン時はTextFieldは入力可にするが、0文字の場合はButtonを非アクティブにする
* Mediatorは双方向, Facadeは一方向
*/

/*:
## Mediator
* 相談役を表現するインターフェース
* Mediatorが管理するメンバーを生成するメソッドを持つ
* メンバーから呼び出される相談メソッドを持つ
*/
protocol Mediator {
    func createColleagues()
    func colleaguesChanged()
}

/*:
## ConcreteMediator
* ConncreteCollegueは再利用しやすいが、ConcreteMediatorは再利用しずらいというメリットがある
* アプリケーションの依存性が高い部分はここに閉じ込められる
*/
class LoginFrame: UIView, Mediator {
    enum State {
        case Login
        case Logout
    }
    
    private var button: ColleagueButton?
    private var textView: ColleagueTextView?
    
    private var state: State = .Logout
    
    override func awakeFromNib() {
        createColleagues()
    }
    
    func createColleagues() {
        button = ColleagueButton()
        textView = ColleagueTextView()
        
        button?.setMediator(mediator: self)
        textView?.setMediator(mediator: self)
        
        if let button = button {
            addSubview(button)
        }
        if let textView = textView {
            addSubview(textView)
        }
    }
    
    func colleaguesChanged() {
        // てきとう
        switch state {
        case .Login:
            button?.setColleagueEnabled(false)
            textView?.setColleagueEnabled(false)
        case .Logout:
            button?.setColleagueEnabled(true)
            textView?.setColleagueEnabled(true)
        }
    }
}

/*:
## Colleague
* Mediatorから呼び出されるMediatorとの契約メソッドを持つ(ex setMediator)
* Mediatorからの指示を受け付けるメソッドを持つ(ex. setColleagueEnabled)
*/
protocol Colleague {
    func setMediator(mediator mediator: Mediator)
    func setColleagueEnabled(enabled: Bool)
}

/*:
## ConcreteColleague
* Colleagueの実装クラス
*/
class ColleagueButton: UIButton, Colleague {
    private var mediator: Mediator?
    
    func setMediator(mediator mediator: Mediator) {
        self.mediator = mediator
    }
    
    func setColleagueEnabled(enabled: Bool) {
        self.enabled = enabled
    }
    
    @IBAction func didTappedButton() {
        mediator?.colleaguesChanged() // 状態変化をメンバー側で処理しない
    }
}

class ColleagueTextView: UITextView, Colleague, UITextViewDelegate {
    private var mediator: Mediator?
    
    func setMediator(mediator mediator: Mediator) {
        self.mediator = mediator
    }
    
    func setColleagueEnabled(enabled: Bool) {
        userInteractionEnabled = enabled
    }
    
    func textViewDidChange(textView: UITextView) {
        mediator?.colleaguesChanged() // 状態変化をメンバー側で処理しない
    }
    
}
