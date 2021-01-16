//
//  IntExtension.swift
//  VK_app
//
//  Created by macbook on 16.01.2021.
//

import Foundation

extension Int {
    func thousands() -> String {
        if self > 1000 {
            return ("\(self/1000)k")
        }
        return String(self)
    }
}
