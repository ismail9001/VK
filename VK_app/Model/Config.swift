//
//  Config.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import RealmSwift

class Config {
    static let apiUrl: String = "https://api.vk.com"
    static let apiVersion: String = "5.126"
    static let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
}