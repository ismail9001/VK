//
//  NewsViewCell.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//

import UIKit

protocol ShowMoreButtonDelegate: class {
    func updateTable(_ cell: NewsViewCell)
}

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var authorPhoto: Avatar!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var photoLike: NewsControl!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet var imageView_HeightConstraint: NSLayoutConstraint!
    
    @IBAction func showMore_Button_Clicked(_ sender: UIButton)
    {
        delegate?.updateTable(self)
    }
    var delegate: ShowMoreButtonDelegate?
    var expanded = false {
        didSet {
            updateTextView()
            updateShowMoreButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateTextView()
        updateShowMoreButton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateTextView() {
            self.newsText.numberOfLines = expanded ? 0 : 3
        }
    
    func updateShowMoreButton() {
        let title = expanded ? "Show less" : "Show more"
            showMoreButton.setTitle(title, for: .normal)
        }
}
