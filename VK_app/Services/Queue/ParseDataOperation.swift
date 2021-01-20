//
//  ParseDataOperation.swift
//  VK_app
//
//  Created by macbook on 20.01.2021.
//

import Foundation
import SwiftyJSON

class ParseDataOperation: Operation {
    
    var outputData:[User] = []
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        do {
            let json = try JSON(data: data)
            var users = json["response"]["items"].arrayValue.compactMap{ User(json: $0) }
            users = users.sorted{ $0.name.lowercased() < $1.name.lowercased() }
            outputData = users
        } catch {
            print (error)
        }
    }
}
