//
//  SaveFriendsOperation.swift
//  VK_app
//
//  Created by macbook on 20.01.2021.
//

import Foundation

class SaveFriendsOperation: AsyncOperation {
    
    let realmService = RealmService()
    override func main() {
        guard let getParsedDataOperation = dependencies.first as? ParseDataOperation else { return }
        let data = getParsedDataOperation.outputData
        realmService.saveRealmUsers(users: data)
        self.state = .finished
    }
}
