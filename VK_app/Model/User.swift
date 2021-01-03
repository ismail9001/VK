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
    @objc dynamic var photoName: String = ""
    let photos = List<Photo>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
        if let url = URL(string: self.photoUrl) {
            let withoutExt = url.deletingPathExtension()
            self.photoName = withoutExt.lastPathComponent + ".jpg"
        }
    }
    
    static var oneUser: User{
        let user =  User(json: "")
        user.id = Int.random(in: 1...Int.max)
        user.name = Lorem.fullName
        user.photoUrl = "\(Int.random(in: 1...15))"
        return user
    }
}
