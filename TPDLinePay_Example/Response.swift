
import Foundation
class Response:Codable{//必須創一個類別來解析jason
    var payment_url :String?
    init(payment_url:String) {
        self.payment_url = payment_url
    }
}
