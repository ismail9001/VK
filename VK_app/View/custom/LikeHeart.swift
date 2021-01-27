//
//  Likes.swift
//  VK_app
//
//  Created by macbook on 22.10.2020.
//
//TODO need to refactor


import UIKit

protocol LikeUpdatingDelegate: class {
    func likeUnlikeFunc(_ sender: UIView)
}

@IBDesignable
class LikeHeart: UIControl {
    
    private var color: UIColor = .gray {
        didSet{
            likeCountLabel.textColor = color
            likeButton.tintColor = color
        }
    }
    
    var liked: Bool = false {
        didSet {
            updateLike()
        }
    }
    
    var likeCount: Int = 0 {
        didSet {
            UIView.transition(with: likeCountLabel, duration: 0.25, options: [.curveEaseInOut, .transitionFlipFromLeft], animations: {
                self.likeCountLabel.text = "\(self.likeCount.thousands())"
            }, completion: nil)
        }
    }
    
    // MARK: - Views
    var likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "0"
        label.backgroundColor = .white
        return label
    }()
    var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        return button
    }()
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        return  stackView
    }()
    
    // MARK: - Delegates
    weak var delegate: LikeUpdatingDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(getGroupedViews([likeCountLabel, likeButton]))
        backgroundColor = .white
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func updateLike() {
        color = liked ? .red : .gray
        likeButton.setImage(liked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeCount = liked ? likeCount + 1 : likeCount - 1
    }
    
    func getGroupedViews (_ views: [UIView])-> UIView{
        let stackView = UIStackView()
        stackView.spacing = 4
        for uiview in views {
            stackView.addArrangedSubview(uiview)
        }
        return stackView
    }
    //MARK: - Actions
    @objc private func likeTap(_ sender: UIView) {
        liked.toggle()
        delegate?.likeUnlikeFunc(self)
    }
    
    //MARK: - Animation

}
