//
//  User.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var photo: Data? = nil
    let photos = List<Photo>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
    }
    
    static var oneUser: User{
        return User(json: "")
    }
}
