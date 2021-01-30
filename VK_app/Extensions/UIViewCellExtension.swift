//
//  UIViewCellExtension.swift
//  VK_app
//
//  Created by macbook on 30.01.2021.
//

import UIKit


protocol PhotoUpdatingDelegate: class {
    func updatePhoto(photo: UIImage, indexPath: IndexPath)
}

extension UITableViewCell: PhotoUpdatingDelegate {
    func updatePhoto(photo: UIImage, indexPath: IndexPath) {
    }
    
    
}
