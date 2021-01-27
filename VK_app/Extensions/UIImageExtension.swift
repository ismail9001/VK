//
//  UIImageExtension.swift
//  VK_app
//
//  Created by macbook on 05.12.2020.
//


import UIKit
import Kingfisher

extension UIImageView {
    
    func getImageFromCache(imageName: String?, imageUrl: String) {
        if let imageName = imageName, let savedImage = UIImageView.getSavedImage(named: imageName) {
            self.image = savedImage
        }
        else {
            print("нет сохр фото")
            self.image = UIImage(named: "camera_200")
            self.load(uiImage: self, url: imageUrl)
        }
    }
    
    private func load(uiImage: UIImageView, url: String) {
        var imageName = ""
        if let url1 = URL(string: url) {
            let withoutExt = url1.deletingPathExtension()
            imageName = withoutExt.lastPathComponent
        }
        guard let imageUrl = URL(string: url) else { return }
        DispatchQueue.global().async { [weak self] in
            KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
                switch result {
                case .success(let value):
                    uiImage.image = value.image
                    _ = uiImage.saveImage(image: value.image, imageName: imageName)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func saveImage(image: UIImage, imageName: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(imageName).jpg")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    private static func imageFromUrl (url: String) -> UIImage {
        guard let defaultImage = UIImage(named: "camera_200") else { return UIImage()}
        guard let imageUrl = URL(string: url) else { return defaultImage}
        guard let data = try? Data(contentsOf: imageUrl) else { return defaultImage }
        guard let image = UIImage(data: data) else { return defaultImage}
        return image
    }
    
    private static func imageFromData (data: Data) -> UIImage {
        guard let defaultImage = UIImage(named: "camera_200") else { return UIImage()}
        guard let image = UIImage(data: data) else { return defaultImage}
        return image
    }
    
     static func getSavedImage(named: String) -> UIImage? {
        guard let defaultImage = UIImage(named: "camera_200") else { return UIImage()}
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return defaultImage
    }
}
