//
//  News.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//
import Foundation
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
    
    init(id: Int, date: Double, likes: Int, lookUps: Int, shares: Int, comments: Int, source_id : Int, postType: String){
        self.id = id
        let date = NSDate(timeIntervalSince1970: date)
        self.newsDate = date as Date
        self.likeCount = likes
        self.lookUpCount = lookUps
        self.shareCount = shares
        self.commentCount = comments
        self.source_id = source_id
        if postType == "post"{
            self.postType = postTypes.post
        } else {
            self.postType = postTypes.photo
        }
    }
}

class PostNews: News {
    var newsText: String!
    var newsImageUrl: String!
    
    init(json: JSON) {
        self.newsText = json["text"].stringValue
        
        self.newsImageUrl = ""
        if let photosArray = json["photos"]["items"].arrayValue.first?["sizes"] {
            for (_, object) in photosArray {
                if object["type"] == "x"
                {self.newsImageUrl = object["url"].stringValue}
            }
        }
        super.init(id: json["post_id"].intValue, date: json["date"].doubleValue, likes: json["likes"]["count"].intValue, lookUps: json["views"]["count"].intValue, shares: json["reposts"]["count"].intValue, comments: json["comments"]["count"].intValue, source_id: json["source_id"].intValue, postType: json["type"].stringValue)
    }
}

class PhotoNews: News {
    var newsImageUrl: String!
    
    init(json: JSON) {
        
        self.newsImageUrl = ""
        if let photosArray = json["photos"]["items"].arrayValue.first?["sizes"] {
            for (_, object) in photosArray {
                if object["type"] == "x"
                {self.newsImageUrl = object["url"].stringValue}
            }
        }
        super.init(id: json["post_id"].intValue, date: json["date"].doubleValue, likes: json["likes"]["count"].intValue, lookUps: json["views"]["count"].intValue, shares: json["reposts"]["count"].intValue, comments: json["comments"]["count"].intValue, source_id: json["source_id"].intValue, postType: json["type"].stringValue)
    }
}
