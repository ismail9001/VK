//
//  Group.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var photo: Data? = nil
    
    convenience init(json: JSON) {
        self.init()
        self.title = json["name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
    }
    
    static var oneGroup: Group {
        return Group(json: "")
    }
}
