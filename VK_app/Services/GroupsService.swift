//
//  GroupsService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class GroupsService {
    
    let baseUrl = Config.apiUrl

    func getGroupsList (completion: @escaping ([Group]) -> Void){
        
        let path = "/method/groups.get?"
        // параметры
        let parameters: Parameters = [
            "extended": 1,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let groups = json["response"]["items"].arrayValue.compactMap{ Group(json: $0) }
                completion(groups)
            } catch {
                print (error)
                completion([])
            }
        }
    }
    
    func groupsSearch(_ search: String) {
        
        let path = "/method/groups.search?"
        // параметры
        let parameters: Parameters = [
            "q": search,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
            
        }
    }
}
