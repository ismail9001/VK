//
//  newsControl.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//

import UIKit

class NewsControl: LikeHeart {

    // MARK: - Views
    
    private var commentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = .gray
        //button.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        return button
    }()
    
    var commentCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "0"
        return label
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.tintColor = .gray
        //button.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        return button
    }()
    
    var shareCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "0"
        return label
    }()
    
    private var lookUp: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .gray
        //button.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        return button
    }()
    
    var lookUpCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "0"
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        stackView.addArrangedSubview(getGroupedViews([shareCount, shareButton]))
        stackView.addArrangedSubview(getGroupedViews([lookUpCount, lookUp]))
        stackView.addArrangedSubview(getGroupedViews([commentCount, commentButton]))
    }
}
