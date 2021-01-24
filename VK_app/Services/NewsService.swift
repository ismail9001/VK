//
//  NewsService.swift
//  VK_app
//
//  Created by macbook on 13.01.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsService {
    
    let baseUrl = Config.apiUrl
    
    func getNewsList(completion: @escaping ([News]) -> Void){
        
        let path = "/method/newsfeed.get?"
        // параметры
        let postParameters: Parameters = [
            "filters": "post",
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        
        let photoParameters: Parameters = [
            "filters": "wall_photo",
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        var allNews:[News] = []
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        newsParse(type: PostNews.self, url: url, parameters: postParameters){ news in
            allNews += news
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        newsParse(type:PhotoNews.self, url: url, parameters: photoParameters){ news in
            allNews += news
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(allNews.sorted(by: { $0.newsDate > $1.newsDate }))
        }
    }
    
    func newsParse<T: News>(type: T.Type, url:String, parameters: Parameters, completion: @escaping ([T]) -> Void){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                var parsedNews:[T] = []
                var parsedUsers:[User] = []
                var parsedGroups:[Group] = []
                parsedNews = json["response"]["items"].arrayValue.compactMap{ T(json: $0) }
                parsedUsers = json["response"]["profiles"].arrayValue.compactMap{ User(json: $0) }
                parsedGroups = json["response"]["groups"].arrayValue.compactMap{ Group(json: $0) }
                for eachPost in parsedNews {
                    let author = self.authorCalculate(newsFeed: eachPost, users: parsedUsers, groups: parsedGroups)
                    eachPost.authorName = author.0
                    eachPost.authorPhotoUrl = author.1
                }
                completion(parsedNews)
            } catch {
                print (error)
                completion([])
            }
        }
    }
    
    func authorCalculate<T: News>(newsFeed: T, users: [User], groups: [Group]) -> (String, String) {
        if newsFeed.source_id > 0 {
            newsFeed.authorName = users.first(where: {$0.id == newsFeed.source_id})?.name ?? ""
            newsFeed.authorPhotoUrl = users.first(where: {$0.id == newsFeed.source_id})?.photoUrl ?? ""
        } else {
            //При первом запуске приложения иногда здесь падает
            newsFeed.authorName = groups.first(where: {$0.id == -newsFeed.source_id})?.title ?? ""
            newsFeed.authorPhotoUrl = groups.first(where: {$0.id == -newsFeed.source_id})?.photoUrl ?? ""
        }
        return (newsFeed.authorName, newsFeed.authorPhotoUrl)
    }
}
