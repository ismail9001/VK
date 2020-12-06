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
    
    @objc dynamic var liked: Bool = false
    @objc dynamic var likes: Int = 0
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var photo: Data? = nil
    
    convenience init(json: JSON) {
        self.init()
        self.liked = json["likes"]["user_likes"].intValue == 0 ? false : true
        self.likes = json["likes"]["count"].intValue
        self.photoUrl = ""
        for (_, object) in json["sizes"] {
            if object["type"] == "x"
            {self.photoUrl = object["url"].stringValue}
        }
    }
    
    static var onePhoto: Photo{
        return Photo(json: "")
    }
}
