//
//  GroupsService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class GroupsService {
    
    let baseUrl = Config.apiUrl
    let queue = DispatchQueue.main
    
    /*func getGroupsList() -> Promise<[Group]>{
        
        let path = "/method/groups.get?"
        // параметры
        let parameters: Parameters = [
            "extended": 1,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        return Alamofire.request(url, method: .get, parameters: parameters).responseJSON()
            .map(on: queue) { json, response -> [Group] in
                let json = JSON(json)
                let groups = json["response"]["items"].arrayValue.compactMap{ Group(json: $0) }
                return(groups.sorted{ $0.title.lowercased() < $1.title.lowercased()})
            }
    }*/
    func getGroupsList (completion: @escaping ([Group]) -> Promise<[Group]>){
        let getDataPromise = GetDataPromiss()
        let request = requestCreating()
        let parseDataPromise = ParseDataPromise()
        let realmService = RealmService()
        getDataPromise.fetchData(request: request)
            .then{data -> Promise<[Group]> in
                return parseDataPromise.parseData(for: data)
            }.then{groups -> Promise<[Group]> in
                return completion(groups)
            }.done{groups in
                realmService.saveRealmGroups(groups: groups)
            }.catch{error in
                print(error)
            }
    }
    private func requestCreating() -> DataRequest{
        let path = "/method/groups.get?"
        // параметры
        let parameters: Parameters = [
            "extended": 1,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        return(Alamofire.request(url, method: .get, parameters: parameters))
    }
    
    func groupsSearch(_ search: String)-> Promise<[Group]> {
        
        let path = "/method/groups.search?"
        // параметры
        let parameters: Parameters = [
            "q": search,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        return Alamofire.request(url, method: .get, parameters: parameters).responseJSON()
            .map(on: queue) { json, response -> [Group] in
                let json = JSON(json)
                let groups = json["response"]["items"].arrayValue.compactMap{ Group(json: $0) }
                return(groups.sorted{ $0.title.lowercased() < $1.title.lowercased()})
            }
    }
    
    func joinInGroup(_ groupId: Int) -> Promise<Bool>   {
        
        let path = "/method/groups.join?"
        // параметры
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        return Alamofire.request(url, method: .get, parameters: parameters).responseJSON()
            .map(on:queue) { json, response -> Bool in
                let json = JSON(json)
                return(json["response"] == 1 ? true : false)
            }
    }
    
    func leaveFromGroup(_ groupId: Int) -> Promise<Bool>   {
        
        let path = "/method/groups.leave?"
        // параметры
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = baseUrl+path
        return Alamofire.request(url, method: .get, parameters: parameters).responseJSON()
            .map(on: queue) { json, response in
                let json = JSON(json)
                return(json["response"] == 1 ? true : false)
            }
    }
}
