//
//  NewsViewCell.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//

import UIKit

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var authorPhoto: Avatar!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var photoLike: NewsControl!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
