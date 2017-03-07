import Foundation

struct Tweet {
    let name: String
    let text: String
    let iconURLString: String
    
    init(dic: [String: Any]) {
        let user = dic["user"] as! [String: Any]
        name = user["name"] as! String
        text = dic["text"] as! String
        iconURLString = user["profile_image_url_https"] as! String
    }
}
