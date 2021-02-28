//
//  FriendPhotosViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class FriendPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, LikeUpdatingCellProtocol, UpdateViewProtocol {
    
    lazy var contentView = self.view as! FriendsPhotosView
    let cellIndent: CGFloat = 20
    var albumId = 0
    var photos : [Photo] = []
    var user : User?
    weak var delegate : UserUpdatingDelegate?
    let imageService = ImageService()
    let friendsPhotosAdapter = FriendPhotosAdapter()
    
    //MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userProperty = user else { return }
        self.title = userProperty.name
        friendsPhotosAdapter.updateDelegate = self
        friendsPhotosAdapter.getPhotos(user: userProperty, albumId: albumId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        contentView.sliderLeftView.removeFromSuperview()
        contentView.sliderRightView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photos = []
        contentView.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSections = photos.isEmpty ? 0 : 1
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendPhotosViewCell
        imageService.getImageFromCache(imageName: photos[indexPath.row].photoName, imageUrl: photos[indexPath.row].photoUrl, uiImageView: cell.friendPhoto)
        cell.photoLike.liked = photos[indexPath.row].liked
        cell.photoLike.likeCount = photos[indexPath.row].likes
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotosViewCell
        contentView.imageTapped(cell, indexPath, photos)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Functions
    
    func updateView(photos: [Photo]) {
        self.photos = photos
        self.contentView.collectionView.reloadData()
    }
    
    //расчет поведения лайка
    //TODO: - сделать сохранение лайков в базу и в апи
    func cellLikeUpdating(_ sender: UIView) {
        let cell = sender
        guard let indexPath = contentView.collectionView.indexPath(for: cell as! UICollectionViewCell) else { return }
        //photos[indexPath.row].likes = photos[indexPath.row].liked ? photos[indexPath.row].likes - 1 : photos[indexPath.row].likes + 1
        //photos[indexPath.row].liked.toggle()
        //delegate?.updateUser(photos: photos, id: user?.id ?? 0)
    }
}
