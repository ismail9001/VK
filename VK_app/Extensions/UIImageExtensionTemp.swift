//
//  UIImageExtension.swift
//  VK_app
//
//  Created by macbook on 30.11.2020.
//

import UIKit

extension UIImageView {
    func load(url: String, completion: @escaping (UIImage) -> Void) {
        guard let imageUrl = URL(string: url) else { return }
        DispatchQueue.main.async {
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    self.image = image
                    completion(image)
                }
            }
        }
    }
}
