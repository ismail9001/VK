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
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var photoName: String = ""
    @objc dynamic var liked: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.title = json["name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
        if let url = URL(string: self.photoUrl) {
            let withoutExt = url.deletingPathExtension()
            self.photoName = withoutExt.lastPathComponent + ".jpg"
        }
    }
}
