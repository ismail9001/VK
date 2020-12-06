//
//  Loader.swift
//  VK_app
//
//  Created by macbook on 11.11.2020.
//

import UIKit

@IBDesignable
class Loader: UIView {
    
    let loaderDuration = 3
    
    private var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.gray.cgColor
        layer.fillColor = UIColor.white.cgColor
        layer.lineWidth = 3.0
        layer.lineCap = CAShapeLayerLineCap.round
        layer.shadowOpacity = 0.9
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 14
        layer.shadowOffset = CGSize(width: 1, height: 1)
        return layer
    }()
    
    var cloud: UIView = {
        let view = UIView()
        //shadow.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        closeLoadingScreen()
        setupStrokePath()
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        closeLoadingScreen()
        setupStrokePath()
        startAnimation()
    }
    
    private func setup () {
        self.addSubview(cloud)

        NSLayoutConstraint.activate([
            cloud.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cloud.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cloud.widthAnchor.constraint(equalToConstant: 80),
            cloud.heightAnchor.constraint(equalToConstant: 80)
        ])
        cloud.setNeedsLayout()
        cloud.layoutIfNeeded()
    }
    private func closeLoadingScreen() {
        UIView.animate(withDuration: 0.5, delay: TimeInterval(loaderDuration), options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.layer.removeAllAnimations()
        })
    }
    
    func setupStrokePath() {
        let path = createBezierPath()
        shapeLayer.path = path.cgPath

            let bezierPathHeight = path.cgPath.boundingBox.height
            let bezierPathWidth = path.cgPath.boundingBox.width

        shapeLayer.position = CGPoint(x: (cloud.frame.width - (bezierPathWidth * cloud.bounds.width / bezierPathWidth))/2, y: (cloud.frame.height - (bezierPathHeight * cloud.bounds.height / bezierPathWidth))/2)
            shapeLayer.setAffineTransform(CGAffineTransform.init(scaleX: cloud.bounds.width / bezierPathWidth, y: cloud.bounds.height / bezierPathWidth))
        cloud.layer.addSublayer(shapeLayer)
    }
    
    func createBezierPath() -> UIBezierPath {
        // create a new path
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 7, y: 23))
        
        for _ in 0...10 {
            path.addLine(to: CGPoint(x: 29, y: 23))
            path.addArc(withCenter: CGPoint(x: 29, y: 16),
                        radius: 7,
                        startAngle: CGFloat(Double.pi / 2), // 90
                        endAngle: CGFloat(29 * Double.pi  / 18), // 290
                        clockwise: false)
            path.addArc(withCenter: CGPoint(x: 26, y: 10),
                        radius: 5,
                        startAngle: CGFloat(35 * Double.pi  / 18), // 350
                        endAngle: CGFloat(23 * Double.pi  / 18), // 230
                        clockwise: false)
            path.addArc(withCenter: CGPoint(x: 15, y: 9),
                        radius: 8,
                        startAngle: CGFloat(17 * Double.pi / 9), // 340
                        endAngle: CGFloat(17 * Double.pi  / 18), // 170
                        clockwise: false)
            path.addArc(withCenter: CGPoint(x: 7, y: 17),
                        radius: 6,
                        startAngle: CGFloat(3 * Double.pi / 2),
                        endAngle: CGFloat(Double.pi / 2), // 90 radians = 270 degrees = straight up
                        clockwise: false) // startAngle to endAngle goes in a clockwise direction
        }
        
        path.close()
        return path
    }
    
    func startAnimation() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.duration = 30
        strokeStartAnimation.repeatCount = 10
        strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.5
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = 30
        strokeEndAnimation.repeatCount = 10
        
        shapeLayer.add(strokeStartAnimation, forKey: nil)
        shapeLayer.add(strokeEndAnimation, forKey: nil)
    }
}
