//
//  FriendsService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class FriendService {
    
    let baseUrl = Config.apiUrl
    
    func getFriendsList(completion: @escaping ([User]) -> Void){
        
        let path = "/method/friends.get?"
        // параметры
        let parameters: Parameters = [
            "fields": "photo_100",
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let users = json["response"]["items"].arrayValue.compactMap{ User(json: $0) }
                completion(users)
            } catch {
                print (error)
                completion([])
            }
        }
    }
}
