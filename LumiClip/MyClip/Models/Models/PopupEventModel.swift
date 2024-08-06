import UIKit

class PopupEventModel: NSObject {
    var message: String
    var image: String
       override init(){
        message = ""
        image = ""
    }
    init(message: String, image: String) {
        self.message = message
        self.image = image
    }
}
