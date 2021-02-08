//
//  FriendsAlbumViewCell.swift
//  VK_app
//
//  Created by macbook on 07.02.2021.
//


import UIKit
import Kingfisher

class FriendsAlbumViewCell: UICollectionViewCell {
    @IBOutlet weak var albumPhoto: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var fotoCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumPhoto.kf.cancelDownloadTask()
        albumPhoto.image = nil
    }
}
