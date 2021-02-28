//
//  FriendPhotosService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Alamofire
import SwiftyJSON

class FriendsPhotosService {
    
    let baseUrl = Config.apiUrl
    
    func getFriendsPhotosList(user: User, albumId: Int, completion: @escaping ([Photo]) -> Void){
        let path = "/method/photos.get?"
        // параметры
        let parameters: Parameters = [
            "extended": 1,
            "owner_id": user.id,
            "album_id": albumId,
            "photo_sizes": 1,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        
        let url = baseUrl+path
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let photos = json["response"]["items"].arrayValue.compactMap{ Photo(json: $0, user: user) }
                completion(photos.sorted{ $0.id < $1.id})
            } catch {
                print (error)
                completion([])
            }
        }
    }
}
