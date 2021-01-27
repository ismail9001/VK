//
//  ParseDataPromise.swift
//  VK_app
//
//  Created by macbook on 27.01.2021.
//

import Foundation
import SwiftyJSON
import PromiseKit

class ParseDataPromise {
    enum ApplicationError: Error {
        case noData
        case jsonParsingError
    }
    var outputData:[Group] = []
    func parseData(for data: Data) -> Promise<[Group]>{
        let (promise, resolver) = Promise<[Group]>.pending()
        do {
            let json = try JSON(data: data)
            let groups = json["response"]["items"].arrayValue.compactMap{ Group(json: $0) }
            resolver.fulfill(groups.sorted{ $0.title.lowercased() < $1.title.lowercased()})
        } catch {
            resolver.reject(ApplicationError.jsonParsingError)
        }
        return promise
    }
}
