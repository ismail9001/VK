//
//  UIPanGestureRecognizerExtension.swift
//  VK_app
//
//  Created by macbook on 28.11.2020.
//

import UIKit

extension UIPanGestureRecognizer {
    
    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
    }
    
    // Get current vertical direction
    //
    // - Parameter target: view target
    // - Returns: current direction
    func verticalDirection(_ target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }
    
    // Get current horizontal direction
    //
    // - Parameter target: view target
    // - Returns: current direction
    func horizontalDirection(_ target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }
    
    // Get a tuple for current horizontal/vertical direction
    //
    // - Parameter target: view target
    // - Returns: current direction
    func versus(_ target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(_: target), self.verticalDirection(_: target))
    }
}

