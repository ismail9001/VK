//
//  CustomPopAnimator.swift
//  VK_app
//
//  Created by macbook on 11.11.2020.
//
import UIKit

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    

    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {
            return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        
        destination.view.setAnchorPoint(CGPoint(x: 1, y: 0))
        source.view.setAnchorPoint(CGPoint(x: 1, y: 0))
        destination.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        source.view.transform = CGAffineTransform(rotationAngle: 3 * CGFloat.pi / 2)
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        destination.view.transform = CGAffineTransform(rotationAngle: 0)
                                                       })
                                }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
}
