//: Playground - noun: a place where people can play

import UIKit

/*:
# Strategyパターン
* アルゴリズムを切り替え、同じ問題を別の方法で解くのを容易にする
* アルゴリズムを意識的に分離するので、容易にアルゴリズムの切り替えを行うことができるようになる
* また動的な変更も可能なので、状態に応じてアルゴリズムを切り替えるということも可能
*/


/*:
## Object
*/
class Hand {
    enum HandValue: Int {
        case Guu = 0
        case Cho = 1
        case Paa = 2
        case Unknown = 3
        
        init(value: Int) {
            switch value {
            case HandValue.Guu.rawValue: self = .Guu
            case HandValue.Cho.rawValue: self = .Cho
            case HandValue.Paa.rawValue: self = .Paa
            default: self = .Unknown
            }
        }
        
        var name: String {
            switch self {
            case .Guu: return "グー"
            case .Cho: return "チョキ"
            case .Paa: return "パー"
            case .Unknown: return ""
            }
        }
    }
    private var value: HandValue?
    
    init(value: HandValue) {
        self.value = value
    }
    
    func isStrongerThan(h: Hand) -> Bool {
        return (fight(h) == .Win) ? true : false
    }
    
    func isWeakerThan(h: Hand) -> Bool {
        return (fight(h) == .Lose) ? true : false
    }
    
    enum Result: Int {
        case Draw = 0
        case Win = 1
        case Lose = 2
        case Unavailable = 3
    }
    private func fight(h: Hand) -> Result {
        guard let myValue = value, let partnerValue = h.value else { return .Unavailable }
        if myValue == partnerValue {
            return .Draw
        } else if (myValue.rawValue + 1) % 3 == partnerValue.rawValue {
            return .Win
        } else {
            return .Lose
        }
    }
}

/*:
## Strategy
* 戦略を利用するためのインターフェースを定める
*/
protocol Strategy {
    func nextHand() -> Hand
    func study(win: Bool)
}

/*:
## ConcreteStrategy
* 具体的な戦略を実装するクラス
* 前回の勝負に勝った場合、同じ手を出す戦略をとる
*/
class WinningStrategy: Strategy {
    private var won = false
    private var prevHand = Hand(value: Hand.HandValue(value: Int(arc4random() % 2)))
    
    func nextHand() -> Hand {
        if !won {
            prevHand = randomHand()
        }
        return prevHand
    }
    
    func study(win: Bool) {
        won = win
    }
    
    private func randomHand() -> Hand {
        let random = Int(arc4random() % 2)
        let hand = Hand(value: Hand.HandValue(value: random))
        return hand
    }
}

/*:
## ConcreteStrategy
* 具体的な戦略を実装するクラス
* 次の手は乱数で決めるが、過去の履歴を考慮して確率を変更する
*/
class ProbStrategy: Strategy {
    private var prevHandValue = Hand.HandValue.Unknown
    private var currentHandValue = Hand.HandValue.Unknown
    private var history = [[1, 1, 1], [1, 1, 1], [1, 1, 1]]
    
    func nextHand() -> Hand {
        let bet = Int(arc4random()) % getSum(0)
        let handValue: Hand.HandValue
        if bet < history[currentHandValue.rawValue][0] {
            handValue = .Guu
        } else if bet < history[currentHandValue.rawValue][0] + history[currentHandValue.rawValue][1] {
            handValue = .Cho
        } else {
            handValue = .Paa
        }
        prevHandValue = currentHandValue
        currentHandValue = handValue
        return Hand(value: handValue)
    }
    
    private func getSum(hv: Int) -> Int {
        var sum = 0
        (0..<3).forEach { (let i) in
            sum += history[hv][i]
        }
        return sum
    }
    
    func study(win: Bool) {
        if win {
            history[prevHandValue.rawValue][currentHandValue.rawValue]++
        } else {
            history[prevHandValue.rawValue][(currentHandValue.rawValue + 1) % 3]++
            history[prevHandValue.rawValue][(currentHandValue.rawValue + 2) % 3]++
        }
    }
}

/*:
## Context
* Strategyを利用するクラス
* Strategyのインスタンスを保持している
*/
class Player {
    private var name = ""
    private var strategy: Strategy?
    private var winCount = 0
    private var loseCount = 0
    private var gameCount = 0
    
    init(name: String, strategy: Strategy) {
        self.name = name
        self.strategy = strategy
    }
    
    func nextHand() -> Hand {
        guard let strategy = strategy else { return Hand(value: Hand.HandValue.Unknown) }
        return strategy.nextHand()
    }
    
    func win() {
        strategy?.study(true)
        winCount++
        gameCount++
    }
    
    func lose() {
        strategy?.study(false)
        loseCount++
        gameCount++
    }
    
    func draw() {
        gameCount++
    }
    
    func toString() -> String {
        return "[\(name):\(gameCount) games, \(winCount) win, \(loseCount) lose]"
    }
}

/*:
## Main
*/
class Main {
    func exec() {
        let player1 = Player(name: "Taro", strategy: WinningStrategy())
        let player2 = Player(name: "Hana", strategy: ProbStrategy())
        (0..<10000).forEach { (let i) in
            let nextHand1 = player1.nextHand()
            let nextHand2 = player2.nextHand()
            if nextHand1.isStrongerThan(nextHand2) {
                print("winner:\(player1)")
                player1.win()
                player2.lose()
            } else if nextHand2.isStrongerThan(nextHand1) {
                print("winner:\(player2)")
                player1.lose()
                player2.win()
            } else {
                print("even")
                player1.draw()
                player2.draw()
            }
        }
        print("Total result:")
        print(player1.toString())
        print(player2.toString())
    }
}

