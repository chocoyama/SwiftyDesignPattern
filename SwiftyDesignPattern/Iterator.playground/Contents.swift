//: Playground - noun: a place where people can play

import UIKit

/*:
# Iteratorパターン
* 繰り返し処理を抽象化して扱うようにするパターン
* ConcreteIteratorオブジェクトを生成するメソッドを持った（Aggregateインターフェースを実装した）ConcreteAggregateオブジェクトを生成
* ConcreteAggregateオブジェクトがConcreteIteratorを生成するときに自身をIteratorに渡し、Iteratorはそれを保持する
* ConcreteIteratorは保持しているConcreteAggregateオブジェクトを操作して繰り返し処理を行っていく
*
* 数え上げの仕組みがAggregateの外に置かれているため、1つのConcreteAggregateに対して複数のConcreteIteratorを作ることも可能
*/

/*:
## Aggregate
* 集合体を表すインターフェース
* 集合体に対応するIteratorを1個作成するためのiteratorメソッドの宣言を行う
*/
protocol Aggregate {
    func iterator() -> Iterator
}


/*:
## Iterator
* 数え上げを行うインターフェース
* hasNext: 次の要素が存在するかどうかを調べるメソッド
*          最後の要素を得る前はtrueを返すが、最後の要素を得た後はfalseを返す。「次にnextメソッドを呼んでも問題ないか調べる」もの
* next: 次の要素を得るためのメソッド。また、このメソッド内部で内部状態を次に進めておく処理も行う
*       厳密に表現するとreturnCurrentElementAndAdvanceToNextPositionという風に呼ぶべきもの
*/
protocol Iterator {
    func hasNext() -> Bool
    func next() -> AnyObject?
}

/*:
## Object(Book)
*/
class Book {
    private let name: String
    
    init(name: String){
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
}

/*:
## ConcreteAggregate(BookShelf)
* Aggregateインターフェースを実装する集合体の実装クラス
*/
class BookShelf: Aggregate {
    private var books = [Book?]()
    private var last = 0
    
    init(maxSize: Int) {
        books = [Book?](count: maxSize, repeatedValue: nil)
    }
    
    func getBookAt(index: Int) -> Book? {
        return books[index]
    }
    
    func appendBook(book: Book) {
        books[last] = book
        last++
    }
    
    func getLength() -> Int {
        return last
    }
    
    func iterator() -> Iterator {
        return BookShelfIterator(bookShelf: self)
    }
}


/*:
## ConcreteIterator(BookShelfIterator)
*/
class BookShelfIterator: Iterator {
    private var bookShelf: BookShelf
    private var index = 0 // その時点で注目しているオブジェクトの添え字
    
    init(bookShelf: BookShelf) {
        self.bookShelf = bookShelf
    }
    
    func hasNext() -> Bool {
        // ConcreteIteratorが保持しているインデックス番号が、Aggregateの総数より上回っているかどうかをチェック
        if index < bookShelf.getLength() {
            return true
        } else {
            return false
        }
    }
    
    func next() -> AnyObject? {
        // その時点で注目しているオブジェクトを返し、さらに「次」へ進める
        let book = bookShelf.getBookAt(index)
        index++
        return book
    }
}

/*:
## Client
* Aggregateインターフェースを実装した（Iteratorを生成するメソッドを持った）集合体オブジェクト(ConcreteAggregate)を作成
* ConcreteAggregateオブジェクトに要素を追加していく
* 繰り返し処理を行いたいタイミングでConcreteAggregateオブジェクトが持つConcreteIterator作成メソッドを呼び出しConcreteIteratorを生成
* ConcreteIteratorのhasNextメソッドでチェックした後に、nextメソッドを実行することで繰り返しの処理を行うことができる
*/
class Client: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookShelf = BookShelf(maxSize: 4)
        bookShelf.appendBook(Book(name: "Around the World in 80 Days"))
        bookShelf.appendBook(Book(name: "Bible"))
        bookShelf.appendBook(Book(name: "Cinderella"))
        bookShelf.appendBook(Book(name: "Daddy-Long-Legs"))
        
        let iterator = bookShelf.iterator()
        while iterator.hasNext() {
            let book = iterator.next() as? Book
            print(book?.getName())
        }
    }
}


