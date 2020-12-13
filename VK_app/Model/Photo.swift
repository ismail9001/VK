//
//  Photo.swift
//  VK_app
//
//  Created by macbook on 21.10.2020.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var liked: Bool = false
    @objc dynamic var likes: Int = 0
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var photo: Data? = nil
    @objc dynamic var user: User? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON, user: User) {
        self.init()
        print("foto created")
        self.id = json["id"].intValue
        self.liked = json["likes"]["user_likes"].intValue == 0 ? false : true
        self.likes = json["likes"]["count"].intValue
        self.photoUrl = ""
        for (_, object) in json["sizes"] {
            if object["type"] == "x"
            {self.photoUrl = object["url"].stringValue}
        }
        self.user = user
    }
    
    /*static var onePhoto: Photo{
        return Photo(json: "", user: nil)
    }*/
}
