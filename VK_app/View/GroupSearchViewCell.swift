//
//  GroupSearchViewCell.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class GroupSearchViewCell: UITableViewCell {
    @IBOutlet weak var groupImage: Avatar!
    @IBOutlet weak var groupName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
