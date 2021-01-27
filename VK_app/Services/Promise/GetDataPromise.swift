//
//  GetDataPromise.swift
//  VK_app
//
//  Created by macbook on 27.01.2021.
//

import PromiseKit
import SwiftyJSON

class GetDataPromiss {
    
    enum ApplicationError: Error {
        case noData
    }
    
    func fetchData(request: DataRequest) -> Promise<Data> {
        let (promise, resolver) = Promise<Data>.pending()
        request.responseJSON{response in
            if let error = response.error {
                resolver.reject(error)
            }
            if let data = response.data {
                resolver.fulfill(data)
            } else {
                resolver.reject(ApplicationError.noData)
            }
        }
        return promise
    }
}
