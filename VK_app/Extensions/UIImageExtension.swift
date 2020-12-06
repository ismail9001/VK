//
//  UIImageExtension.swift
//  VK_app
//
//  Created by macbook on 05.12.2020.
//


import UIKit
import Kingfisher

extension UIImageView {
    func load(url: String, completion: @escaping (UIImage) -> Void) {
        guard let imageUrl = URL(string: url) else { return }
        DispatchQueue.global().async { [weak self] in
            KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
                switch result {
                case .success(let value):
                    self?.image = value.image
                    completion(value.image)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    static func imageFromUrl (url: String) -> UIImage {
        guard let defaultImage = UIImage(named: "camera_200") else { return UIImage()}
        guard let imageUrl = URL(string: url) else { return defaultImage}
        guard let data = try? Data(contentsOf: imageUrl) else { return defaultImage }
        guard let image = UIImage(data: data) else { return defaultImage}
        return image
    }
    
    static func imageFromData (data: Data) -> UIImage {
        guard let defaultImage = UIImage(named: "camera_200") else { return UIImage()}
        guard let image = UIImage(data: data) else { return defaultImage}
        return image
    }
}
