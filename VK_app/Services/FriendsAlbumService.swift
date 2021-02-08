//
//  FriendsAlbumService.swift
//  VK_app
//
//  Created by macbook on 07.02.2021.
//

import Alamofire
import SwiftyJSON

class FriendsAlbumService {
    
    let baseUrl = Config.apiUrl

    func getFriendsAlbumsList (user: User, completion: @escaping ([Album]) -> Void){
        
        let path = "/method/photos.getAlbums?"
        // параметры
        let parameters: Parameters = [
            "need_covers": true,
            "need_system": true,
            "owner_id": user.id,
            "photo_sizes": 1,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        
        let url = baseUrl+path
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let albums = json["response"]["items"].arrayValue.compactMap{ Album(json: $0) }
                completion(albums.sorted{ $0.id < $1.id})
            } catch {
                print (error)
                completion([])
            }
        }
    }
}
