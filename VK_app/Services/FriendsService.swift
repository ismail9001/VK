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
    
    func getFriendsList() -> [User]{
        let friendsOperationQueue = OperationQueue()
        let path = "/method/friends.get?"
        // параметры
        let parameters: Parameters = [
            "fields": "photo_100",
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = Config.apiUrl + path
        let request = AF.request(url, method: .get, parameters: parameters)
        let getDataOperation = GetDataOperation(request: request)
        let parseData = ParseDataOperation()
        let saveFriends = SaveFriendsOperation()
        parseData.addDependency(getDataOperation)
        saveFriends.addDependency(parseData)
        friendsOperationQueue.addOperations([getDataOperation, parseData], waitUntilFinished: true)
        OperationQueue.main.addOperation(saveFriends)
        return parseData.outputData
    }
}
