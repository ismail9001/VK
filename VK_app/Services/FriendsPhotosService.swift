//
//  FriendPhotosService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class FriendsPhotosService {
    
    let baseUrl = Config.apiUrl

    func getFriendsPhotosList(userId: Int, completion: @escaping ([Photo]) -> Void){
        
        let path = "/method/photos.getAll?"
        // параметры
        let parameters: Parameters = [
            "extended": 1,
            "owner_id": userId,
            "photo_sizes": 1,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let photos = json["response"]["items"].arrayValue.compactMap{ Photo(json: $0) }
                completion(photos)
            } catch {
                print (error)
                completion([])
            }
        }
    }
}
