//
//  FriendPhotosViewCell.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import Kingfisher

protocol LikeUpdatingCellProtocol: class {
    func cellLikeUpdating(_ sender: UIView)
}

class FriendPhotosViewCell: UICollectionViewCell, LikeUpdatingDelegate {
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var photoLike: LikeHeart!
    weak var delegate: LikeUpdatingCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoLike.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendPhoto.kf.cancelDownloadTask()
        friendPhoto.image = nil
    }
    
    func likeUnlikeFunc(_ sender: UIView) {
        delegate?.cellLikeUpdating(self)
    }
}
