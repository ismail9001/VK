//
//  News.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//

import SwiftyJSON

class News {
    
    var id: Int
    var authorName: String = ""
    var authorPhotoUrl: String = ""
    var newsDate: Date!
    var likeCount: Int
    var lookUpCount: Int
    var shareCount: Int
    var commentCount: Int
    enum postTypes: String{
        case post
        case photo
    }
    var postType: postTypes
    var source_id: Int
    
    required init(json: JSON){
        self.id = json["post_id"].intValue
        let date = NSDate(timeIntervalSince1970: json["date"].doubleValue)
        self.newsDate = date as Date
        self.likeCount = json["likes"]["count"].intValue
        self.lookUpCount = json["views"]["count"].intValue
        self.shareCount = json["reposts"]["count"].intValue
        self.commentCount = json["comments"]["count"].intValue
        self.source_id = json["source_id"].intValue
        if json["type"].stringValue == "post"{
            self.postType = postTypes.post
        } else {
            self.postType = postTypes.photo
        }
    }
}

class PostNews: News {
    var newsText: String!
    var newsImageUrl: String!
    
    required init(json: JSON) {
        
        super.init(json: json)
        self.newsText = json["text"].stringValue
        self.newsImageUrl = ""
        if let photosArray = json["photos"]["items"].arrayValue.first?["sizes"] {
            for (_, object) in photosArray {
                if object["type"] == "x"
                {self.newsImageUrl = object["url"].stringValue}
            }
        }
    }
}

class PhotoNews: News {
    var newsImageUrl: String!
    var width: Int!
    var height: Int!
    var aspectRatio: CGFloat? { return CGFloat(height)/CGFloat(width) }
    required init (json: JSON) {
        
        super.init(json: json)
        self.newsImageUrl = ""
        if let firstPhotoInNews = json["photos"]["items"].arrayValue.first {
            super.likeCount = firstPhotoInNews["likes"]["count"].intValue
            super.lookUpCount = firstPhotoInNews["views"]["count"].intValue
            super.shareCount = firstPhotoInNews["reposts"]["count"].intValue
            super.commentCount = firstPhotoInNews["comments"]["count"].intValue
            for (_, photo) in firstPhotoInNews["sizes"] {
                if photo["type"] == "x"{
                    self.width = photo["width"].intValue
                    self.height = photo["height"].intValue
                    self.newsImageUrl = photo["url"].stringValue}
            }
            
        }
    }
}
