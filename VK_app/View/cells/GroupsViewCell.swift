//
//  GroupsViewCell.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import Kingfisher

class GroupsViewCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupPhoto: Avatar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupPhoto.avatarPhoto.kf.cancelDownloadTask()
        groupPhoto.avatarPhoto.image = nil
    }
    
}
