//
//  ImageService.swift
//  VK_app
//
//  Created by macbook on 30.01.2021.
//


import UIKit
import Kingfisher

class ImageService: UIImageView {
    
    var imageCash:[String: UIImage] = [:]
    
    func getImageFromCache(imageName: String?, imageUrl: String, uiImageView: UIImageView) {
        if let imageName = imageName, let image = imageCash[imageName] {
            uiImageView.image = image
        } else if let imageName = imageName, let savedImage = self.getSavedImage(named: imageName) {
            uiImageView.image = savedImage
            imageCash[imageName] = savedImage
        } else {
            uiImageView.image = UIImage(named: "camera_200")
            self.load(uiImageView: uiImageView, url: imageUrl)
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
       guard let defaultImage = UIImage(named: "camera_200") else { return UIImage()}
       if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
           return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
       }
       return defaultImage
   }
    
    private func load(uiImageView: UIImageView, url: String) {
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
                    uiImageView.image = value.image
                    self?.saveImage(image: value.image, imageName: imageName)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func saveImage(image: UIImage, imageName: String) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(imageName).jpg")!)
            imageCash[imageName] = image
        } catch {
            print(error.localizedDescription)
        }
    }
}
