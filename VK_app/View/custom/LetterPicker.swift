//
//  LetterPicker.swift
//  VK_app
//
//  Created by macbook on 30.10.2020.
//

import UIKit

class LetterPicker: UIView {
    
    weak var delegate: LetterPickerDelegate?
    var letters: [String] = "abcdefghijklmnopqrstuvwxyz".map {String($0)} {
        didSet {
            reload()
        }
    }
    
    //MARK: - Subviews
    
    private var buttons: [UIButton] = []
    private var lastPressedButton: UIButton?
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .vertical
        return  stackView
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
    
    //MARK: - Functions
    private func setup() {
        backgroundColor = .clear
        setupButtons()
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        addGestureRecognizer(pan)
    }
    private func setupButtons() {
        for letter in letters {
            let button = UIButton(type: .system)
            button.setTitle(letter.uppercased(), for: .normal)
            button.addTarget(self, action: #selector(letterTapped), for: .touchDown)
            buttons.append(button)
            stackView.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
    }
    
    @objc private func letterTapped(_ sender: UIButton) {
        guard lastPressedButton != sender else { return }
        lastPressedButton = sender
        let letter = sender.title(for: .normal) ?? ""
        delegate?.letterPicked(letter)
    }
    
    @objc private func panAction(_ recognizer: UIPanGestureRecognizer) {
        let anchorPoint = recognizer.location(in: self)
        let buttonHeight = bounds.height / CGFloat(buttons.count)
        var buttonIndex = Int(anchorPoint.y / buttonHeight)
        if (buttonIndex >= buttons.count) {
            buttonIndex = buttons.count - 1
        }
        if (buttonIndex < 0) {
            buttonIndex = 0
        }
        deactivateButtons()
        let button = buttons[buttonIndex]
        button.isHighlighted = true
        letterTapped(button)
    }
    
    private func deactivateButtons(){
        buttons.forEach{ $0.isHighlighted = false}
        //buttons.
    }
    
    private func reload() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview()}
        buttons = []
        lastPressedButton = nil
        setupButtons()
    }
}
