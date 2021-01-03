//
//  News.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//
import Foundation

struct News {
    var id: Int
    var author: User
    var newsLabel: String!
    var newsText: String!
    var newsDate: Date!
    var newsImage: String!
    var likeCount: Int
    var lookUpCount: Int
    var shareCount: Int
    var commentCount: Int
    var postType: Bool
    
    static var oneNews: News{
        let postType = Bool.random()
        return News(id: Int.random(in: 1...Int.max),
                    author: User.oneUser,
                    newsLabel: Lorem.title,
                    newsText: postType ? Lorem.tweet : nil,
                    newsDate: Date.randomWithinDaysBeforeToday(7),
                    newsImage: postType ? nil : "groups/\(Int.random(in: 1...15))g",
                    likeCount: Int.random(in: 3...123),
                    lookUpCount: Int.random(in: 3...123),
                    shareCount: Int.random(in: 3...123),
                    commentCount: Int.random(in: 3...123),
                    postType: postType)
    }
    
    static var manyNews: [News] {
        return (10...30).map{_ in News.oneNews}
    }
}

