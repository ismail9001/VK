//
//  GroupSearchView.swift
//  VK_app
//
//  Created by macbook on 27.01.2021.
//

import UIKit

final class FriendsPhotosView: UIView {
    
    // MARK: -Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sliderCenterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var sliderCenterView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    var sliderLeftImage: UIImageView = {
        let image = UIImageView()
        image.frame = UIScreen.main.bounds
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var sliderRightImage: UIImageView = {
        let image = UIImageView()
        image.frame = UIScreen.main.bounds
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var sliderLeftView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        view.frame.origin.x = -1 * view.frame.maxX
        return view
    }()
    
    var sliderRightView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        view.frame.origin.x = view.frame.maxX
        return view
    }()
    
    let screenSize: CGRect = UIScreen.main.bounds
    var animator: UIViewPropertyAnimator!
    var imageService = ImageService()
    var photosCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderLeftView.removeFromSuperview()
        sliderRightView.removeFromSuperview()
    }
    
    //MARK: - Slider
    
    func imageTapped( _ cell: FriendPhotosViewCell, _ indexPath: IndexPath, _ rightImage: UIImage, _ leftImage: UIImage, _ photosCount: Int){
        
        guard let rectOfCellInTableView = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let rectOfCellInSuperview = collectionView.convert(rectOfCellInTableView.frame, to: collectionView.superview)
        sliderCenterImage.image = cell.friendPhoto.image
        sliderCenterView.tag = indexPath.row
        sliderCenterView.frame = CGRect(x: rectOfCellInSuperview.minX, y: rectOfCellInSuperview.minY, width: rectOfCellInSuperview.width, height: rectOfCellInSuperview.height)
        sliderCenterView.addSubview(sliderCenterImage)
        sliderCenterView.layer.masksToBounds = true
        sliderCenterImage.frame = imageRectPos(rectOfCellInTableView, rectOfCellInSuperview)
        sliderCenterView.alpha = cell.alpha
        cell.alpha = 0
        self.photosCount = photosCount
        
        // TODO: -переделать на swipe вниз
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        sliderCenterView.addGestureRecognizer(tap)
        sliderRightImage.image = rightImage
        sliderLeftImage.image = leftImage
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panSlider(_:)))
        sliderCenterView.addGestureRecognizer(pan)
        collectionView.addSubview(sliderCenterView)
        //UIApplication.shared.windows.first?.layer.speed = 0.1
        UIView.animateKeyframes(withDuration: 0.4,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        self.sliderCenterView.alpha = 1
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4 ,
                                                       animations: { [self] in
                                                        
                                                        sliderCenterView.frame = screenSize
                                                        sliderCenterImage.frame = screenSize
                                                        sliderCenterView.backgroundColor = .black
                                                       })
                                })
        sliderRightView.addSubview(sliderRightImage)
        sliderLeftView.addSubview(sliderLeftImage)
        self.addSubview(sliderLeftView)
        self.addSubview(sliderRightView)
    }
    
    @objc func panSlider(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
            if gesture.horizontalDirection(sliderCenterView) == .Left{
                animator.addAnimations {
                    self.sliderCenterView.center.x -= self.sliderCenterView.frame.size.width
                    self.sliderRightView.center.x -= self.sliderRightView.frame.size.width
                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                animator.addCompletion { _ in
                    self.sliderCenterView.center.x += self.sliderCenterView.frame.size.width
                    self.sliderRightView.center.x += self.sliderRightView.frame.size.width
                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.sliderCenterImage.image = self.sliderRightImage.image
                }
            }
            if gesture.horizontalDirection(sliderCenterView) == .Right{
                animator.addAnimations {
                    self.sliderCenterView.center.x += self.sliderCenterView.frame.size.width
                    self.sliderLeftView.center.x += self.sliderLeftView.frame.size.width
                    self.sliderLeftImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                animator.addCompletion { _ in
                    self.sliderCenterView.center.x -= self.sliderCenterView.frame.size.width
                    self.sliderLeftView.center.x -= self.sliderLeftView.frame.size.width
                    self.sliderLeftImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.sliderCenterImage.image = self.sliderLeftImage.image
                }
            }
            animator.pauseAnimation()
        case .changed:
            animator.fractionComplete =  abs(translation.x / frame.width)
        case .ended:
            if animator.fractionComplete > 0.5 {
                let indexPath = IndexPath(row: sliderCenterView.tag, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotosViewCell
                cellAnimationCalculate(cell)
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                if gesture.horizontalDirection(sliderCenterView) == .Left{
                    sliderCenterView.tag = sliderCenterView.tag == photosCount - 1 ? 0 : sliderCenterView.tag + 1
                }
                if gesture.horizontalDirection(sliderCenterView) == .Right{
                    sliderCenterView.tag = sliderCenterView.tag == 0 ? photosCount - 1 : sliderCenterView.tag - 1
                }
                collectionView.scrollToItem(at: IndexPath(row: sliderCenterView.tag, section: 0), at: .centeredVertically, animated: true)
            }
            else {
                animator.stopAnimation(true)
                if (translation.x < 0){
                    UIView.animateKeyframes(withDuration: 1,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderCenterView.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5 ,
                                                                   animations: {
                                                                    self.sliderRightView.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                                                   })
                                            })
                } else {
                    UIView.animateKeyframes(withDuration: 1,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderCenterView.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5 ,
                                                                   animations: {
                                                                    self.sliderLeftView.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderLeftImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                                                   })
                                            })
                }
            }
        default:
            return
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        guard let centerView = sender.view else { return }
        let indexPath = IndexPath(row: centerView.tag, section: 0)
        guard let rectOfCellInTableView = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let rectOfCellInSuperview = collectionView.convert(rectOfCellInTableView.frame, to: collectionView.superview)
        let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotosViewCell
        cellAnimationCalculate(cell)
        UIView.animateKeyframes(withDuration: 0.4,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        self.sliderCenterView.alpha = 0
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4 ,
                                                       animations: { [self] in
                                                        sliderCenterView.frame = rectOfCellInSuperview
                                                        sliderCenterImage.frame = imageRectPos(rectOfCellInTableView, rectOfCellInSuperview)
                                                        sliderCenterImage.backgroundColor = .clear
                                                       })
                                }, completion: { _ in
                                    sender.view?.removeFromSuperview()
                                })
    }
    
    //расчет области отображения ImageView на месте расположения ячейки
    func imageRectPos(_ cellRect: UICollectionViewLayoutAttributes, _ frameRect: CGRect) -> CGRect {
        
        var width: CGFloat = frameRect.width
        var height: CGFloat = frameRect.height
        var x: CGFloat = 0
        var y: CGFloat = 0
        guard let image = sliderCenterImage.image else { return CGRect(x: x, y: y, width: width, height: height)}
        
        if image.size.height / image.size.width > 1 {
            height = (frameRect.width / image.size.width) * image.size.height
            y = (frameRect.height - height) / 2
        } else if image.size.height / image.size.width != 1 {
            width = (frameRect.height / image.size.height)  * image.size.width
            x = (frameRect.width - width) / 2
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //обновляем свойства центрального экрана слайдера
    func updateImageSlider(_ image: UIImage) {
        sliderCenterImage.image = image
        sliderCenterView.frame.origin.x = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let arr = collectionView.indexPathsForVisibleItems
        for indexPath in arr{
            guard let cell = self.collectionView.cellForItem(at: indexPath) else {return}
            cellAnimationCalculate(cell)
        }
    }
    
    //расчет альфа канала в зависимости от положения ячейки на экране
    func cellAnimationCalculate (_ cell: UICollectionViewCell) {
        let pos = self.collectionView.convert(cell.frame, to: self)
        var alpha: CGFloat = 0
        if (pos.origin.y < cell.frame.height) {
            alpha = pos.origin.y / cell.frame.height
            alpha = alpha < 0 ? 0 : alpha
            cell.alpha = alpha
        } else if (pos.origin.y > screenSize.maxY - 2 * cell.frame.height) {
            alpha = 1 - ((pos.origin.y - (screenSize.maxY - 2 * cell.frame.height)) / cell.frame.height)
            alpha = alpha < 0 ? 0 : alpha
            cell.alpha = alpha
        } else {
            cell.alpha = 1
        }
    }
    
    //MARK: - Animation
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellAnimationCalculate(cell)
    }
}
