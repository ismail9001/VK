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
            postNewsParse(url: url, parameters: postParameters){ news in
                allNews += news
                dispatchGroup.leave()
            }
        dispatchGroup.enter()
            photoNewsParse(url: url, parameters: photoParameters){ news in
                allNews += news
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            allNews = allNews.sorted(by: { $0.newsDate > $1.newsDate })
            completion(allNews)
        }
        //newsParse(url: <#T##String#>, parameters: <#T##Parameters#>, completion: <#T##([PostNews]) -> Void#>)
    }
    
    func postNewsParse(url:String, parameters: Parameters, completion: @escaping ([PostNews]) -> Void){
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let dispatchGroup = DispatchGroup()
                var parsedNews:[PostNews] = []
                var parsedUsers:[User] = []
                var parsedGroups:[Group] = []
                
                DispatchQueue.global().async(group: dispatchGroup) {
                    parsedNews = json["response"]["items"].arrayValue.compactMap{ PostNews(json: $0) }
                }
                
                DispatchQueue.global().async(group: dispatchGroup) {
                    parsedUsers = json["response"]["profiles"].arrayValue.compactMap{ User(json: $0) }
                }
                
                DispatchQueue.global().async(group: dispatchGroup) {
                    parsedGroups = json["response"]["groups"].arrayValue.compactMap{ Group(json: $0) }
                }
                
                dispatchGroup.notify(queue: DispatchQueue.main){
                    for eachPost in parsedNews {
                        if eachPost.source_id > 0 {
                            eachPost.authorName = parsedUsers.first(where: {$0.id == eachPost.source_id})!.name
                            eachPost.authorPhotoUrl = parsedUsers.first(where: {$0.id == eachPost.source_id})!.photoUrl
                        } else {
                            //При первом запуске приложения здесь падает
                            eachPost.authorName = parsedGroups.first(where: {$0.id == eachPost.source_id * -1})!.title
                            eachPost.authorPhotoUrl = parsedGroups.first(where: {$0.id == eachPost.source_id * -1})!.photoUrl
                        }
                    }
                    completion(parsedNews)
                }
            } catch {
                print (error)
                completion([])
            }
        }
    }
    
    func photoNewsParse(url:String, parameters: Parameters, completion: @escaping ([PhotoNews]) -> Void){
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let dispatchGroup = DispatchGroup()
                var parsedNews:[PhotoNews] = []
                var parsedUsers:[User] = []
                var parsedGroups:[Group] = []
                
                DispatchQueue.global().async(group: dispatchGroup) {
                    parsedNews = json["response"]["items"].arrayValue.compactMap{ PhotoNews(json: $0) }
                }
                
                DispatchQueue.global().async(group: dispatchGroup) {
                    parsedUsers = json["response"]["profiles"].arrayValue.compactMap{ User(json: $0) }
                }
                
                DispatchQueue.global().async(group: dispatchGroup) {
                    parsedGroups = json["response"]["groups"].arrayValue.compactMap{ Group(json: $0) }
                }
                
                dispatchGroup.notify(queue: DispatchQueue.main){
                    for eachPost in parsedNews {
                        if eachPost.source_id > 0 {
                            eachPost.authorName = parsedUsers.first(where: {$0.id == eachPost.source_id})!.name
                            eachPost.authorPhotoUrl = parsedUsers.first(where: {$0.id == eachPost.source_id})!.photoUrl
                        } else {
                            //При первом запуске приложения здесь падает
                            eachPost.authorName = parsedGroups.first(where: {$0.id == eachPost.source_id * -1})!.title
                            eachPost.authorPhotoUrl = parsedGroups.first(where: {$0.id == eachPost.source_id * -1})!.photoUrl
                        }
                    }
                    completion(parsedNews)
                }
            } catch {
                print (error)
                completion([])
            }
        }
    }
}
