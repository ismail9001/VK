//
//  ArrayExtension.swift
//  VK_app
//
//  Created by macbook on 24.12.2020.
//

import Foundation

extension Array where Element: Hashable {
    
    func filterDuplicates() -> Array<Element> {
        var set = Set<Element>()
        var filteredArray = Array<Element>()
        for item in self {
            if set.insert(item).inserted {
                filteredArray.append(item)
            }
        }
        return filteredArray
    }
}
