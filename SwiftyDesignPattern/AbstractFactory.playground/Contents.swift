//: Playground - noun: a place where people can play

import UIKit

/*:
# AbstractFactoryパターン
* 抽象的な工場で、抽象的な部品を組み合わせて抽象的な製品を作る
* 部品の具体的な実装には注目せずに、インターフェースだけを使って部品を組み立てて製品にまとめる
* 新しい工場を作る際は、（今回のケースでは）Factory, Link, Tray, Pageプロトコルを採用したクラスを作成するだけ
* ※ 新しい部品を追加することは困難になる
*/


/*:
## AbstructProduct
* 抽象的な部品（Link, Trayを同一視するためのクラス）
* 抽象的な部品のインターフェースを定める
*/
protocol Item {
    var caption: String { get set }
    init()
    func makeHTML() -> String
}

extension Item {
    init(caption: String) {
        self.init()
        self.caption = caption
    }
}

/*:
## AbstructProduct
* 抽象的な部品
* 抽象的な部品のインターフェースを定める
* makeHTML()とプロパティが実装されていない
*/
protocol Link: Item {
    var url: String { get set }
}

extension Link {
    init(caption: String, url: String) {
        self.init(caption: caption)
        self.url = url
    }
}

/*:
## AbstructProduct
* 抽象的な部品
* 抽象的な部品のインターフェースを定める
* makeHTML()とプロパティが実装されていない
*/
protocol Tray: Item {
    var tray: [Item] { get set }
}

extension Tray {
    mutating func add(item: Item) {
        self.tray.append(item)
    }
}

/*
## AbstructProduct
* 抽象的な製品
* 抽象的な製品のインターフェースを定める
* makeHTML()とプロパティが実装されていない
*/
protocol Page {
    var title: String { get set }
    var author: String { get set }
    var content: [Item] { get set }
    init()
    func makeHTML() -> String
}

extension Page {
    init(title: String, autor: String) {
        self.init()
        self.title = title
        self.author = author
    }
    
    mutating func add(item: Item) {
        content.append(item)
    }
    func output() {
        let html = makeHTML()
        print(html)
    }
}

/*:
## AbstructFactory
* 抽象的な工場
* AbstructProductを作成するためのインターフェースを定める
* getFactoryで具象クラスを作成するが、返すのは抽象クラス
*/
protocol Factory {
    func createLink(caption: String, url: String) -> Link
    func createTray(caption: String) -> Tray
    func createPage(title: String, author: String) -> Page
}


/*:
## Client
* 依頼者
* AbstructFactory, AbstructProductのインターフェースだけを使う
* 具体的な部品、製品、工場については知る必要がない
*/
class Client {
    func exec() {
        let factory = ListFactory()
        
        let asahi = factory.createLink("朝日新聞", url: "http://www.asahi.com/")
        let yomiuri = factory.createLink("読売新聞", url: "http://www.yomiuri.co.jp/")
        
        let us_yahoo = factory.createLink("Yahoo!", url: "http://www.yahoo.com/")
        let jp_yahoo = factory.createLink("Yahoo!JAPAN", url: "http://www.yahoo.co.jp")
        
        let excite = factory.createLink("Excite", url: "http://www.excite.com/")
        let google = factory.createLink("Google", url: "http://www.google.com/")
        
        var newsTray = factory.createTray("新聞")
        newsTray.add(asahi)
        newsTray.add(yomiuri)
        
        var yahooTray = factory.createTray("Yahoo!")
        yahooTray.add(us_yahoo)
        yahooTray.add(jp_yahoo)
        
        var searchTray = factory.createTray("サーチエンジン")
        searchTray.add(yahooTray)
        searchTray.add(excite)
        searchTray.add(google)
        
        var page = factory.createPage("LinkPage", author: "Taro Yamada")
        page.add(newsTray)
        page.add(yahooTray)
        page.add(searchTray)
        
        page.output()
    }
}

/*:
## ConcreteFactory①
* 具体的な工場
* AbstructFactoryのインターフェースを実装する
*/
class ListFactory: Factory {
    func createLink(caption: String, url: String) -> Link {
        return ListLink(caption: caption, url: url)
    }
    
    func createTray(caption: String) -> Tray {
        return ListTray(caption: caption)
    }
    
    func createPage(title: String, author: String) -> Page {
        return ListPage(title: title, autor: author)
    }
}

/*:
## ConcreteProduct①
* 具体的な部品
* AbstructProductのインターフェースを実装する
*/
class ListLink: Link {
    var url = ""
    var caption = ""
    required init() {}
    func makeHTML() -> String {
        return "<li><a href=\"\(url)\">\(caption)</a></li>"
    }
}

/*:
## ConcreteProduct①
* 具体的な部品
* AbstructProductのインターフェースを実装する
*/
class ListTray: Tray {
    var caption = ""
    var tray = [Item]()
    required init() {}
    func makeHTML() -> String {
        var html = ""
        html += "<li>\n"
        html += "\(caption)\n"
        html += "<ul>\n"
        tray.forEach { html += $0.makeHTML() }
        html += "<ul>\n"
        html += "</li>"
        return html
    }
}

/*:
## ConcreteProduct①
* 具体的な製品
* AbstructProductのインターフェースを実装する*/
class ListPage: Page {
    var title = ""
    var author = ""
    var content = [Item]()
    required init() {}
    func makeHTML() -> String {
        var html = ""
        html += "<html><head><title>\(title)</title></head>\n"
        html += "<body>\n"
        html += "<h1>\(title)</h1>\n"
        html += "<ul>\n"
        content.forEach { html += $0.makeHTML() }
        html += "</ul>\n"
        html += "<hr><address>\(author)</address>"
        html += "</body></html>\n"
        return html
    }
}


/*:
## ConcreteFactory②
* 具体的な工場
* AbstructFactoryのインターフェースを実装する
*/
class TableFactory: Factory {
    func createLink(caption: String, url: String) -> Link {
        return TableLink(caption: caption, url: url)
    }
    
    func createTray(caption: String) -> Tray {
        return TableTray(caption: caption)
    }
    
    func createPage(title: String, author: String) -> Page {
        return TablePage(title: title, autor: author)
    }
}

/*:
## ConcreteProduct②
* 具体的な部品
* AbstructProductのインターフェースを実装する
*/
class TableLink: Link {
    var url = ""
    var caption = ""
    required init() {}
    func makeHTML() -> String {
        return "<td><a href=\"\(url)\">\(caption)</a></td>"
    }
}

/*:
## ConcreteProduct②
* 具体的な部品
* AbstructProductのインターフェースを実装する
*/
class TableTray: Tray {
    var caption = ""
    var tray = [Item]()
    required init() {}
    func makeHTML() -> String {
        var html = ""
        html += "<td>"
        html += "<table width=\"100%\" border=\"1\"><tr>"
        html += "<td bgcolor=\"#cccccc\" align=\"center\" colspan=\"\(tray.count)\"><b>\(caption)</b></td>"
        html += "</tr>\n"
        html += "<tr>\n"
        tray.forEach { html += $0.makeHTML() }
        html += "</tr></table>"
        html += "</td>"
        return html
    }
}

/*:
## ConcreteProduct②
* 具体的な製品
* AbstructProductのインターフェースを実装する
*/
class TablePage: Page {
    var title = ""
    var author = ""
    var content = [Item]()
    required init() {}
    func makeHTML() -> String {
        var html = ""
        html += "<html><head><title>\(title)</title></head>\n"
        html += "<body>\n"
        html += "<h1>\(title)</h1>\n"
        html += "<table width=\"80%\" border=\"3\">\n"
        content.forEach { html += $0.makeHTML() }
        html += "</table>\n"
        html += "<hr><address>\(author)</address>"
        html += "</body></html>\n"
        return html
    }
}
