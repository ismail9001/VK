//
//  SaveDataPromise.swift
//  VK_app
//
//  Created by macbook on 27.01.2021.
//

import PromiseKit
import SwiftyJSON

class SaveDataPromiss {
    
    enum ApplicationError: Error {
        case noData
    }
    let realmService = RealmService()
    
    func saveData(groups: [Group]) {
        realmService.saveRealmGroups(groups: groups)
    }
}
