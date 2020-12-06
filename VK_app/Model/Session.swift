//
//  Session.swift
//  VK_app
//
//  Created by macbook on 22.11.2020.
//

import Foundation

class Session {
    
    static let storedSession = Session()
    private init(){}
    
    var token: String = ""
    var userId: Int = 0
}
