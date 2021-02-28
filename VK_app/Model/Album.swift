//
//  Album.swift
//  VK_app
//
//  Created by macbook on 07.02.2021.
//

import SwiftyJSON

class Album {
    
    var id: Int
    var title: String = ""
    var description: String = ""
    var albumPhotoURL: String = ""
    var size: Int = 0
    
    init(json: JSON){
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.albumPhotoURL = json["album"].stringValue
        for (_, object) in json["sizes"] {
            if object["type"] == "x"
            {self.albumPhotoURL = object["src"].stringValue}
        }
        self.size = json["size"].intValue
    }
}

