//
//  FriendsViewCell.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import Kingfisher

class FriendsViewCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPhoto: Avatar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendPhoto.avatarPhoto.kf.cancelDownloadTask()
        friendPhoto.avatarPhoto.image = nil
    }
}
