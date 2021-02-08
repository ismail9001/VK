//
//  FriendPhotosViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class FriendPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,LikeUpdatingCellProtocol {
    lazy var contentView = self.view as! FriendsPhotosView
    let cellIndent: CGFloat = 20
    var albumId = 0
    var photos : [Photo] = []
    var user : User?
    weak var delegate : UserUpdatingDelegate?
    let realmService = RealmService()
    let imageService = ImageService()
    let friendsPhotosService = FriendsPhotosService()
    
    //MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userProperty = user else { return }
        self.title = userProperty.name
        showPhotos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
        let positions = nearElements(index: cell.friendPhoto.tag)
        guard let rightImage = imageService.getSavedImage(named: photos[positions[2]].photoName),
              let leftImage = imageService.getSavedImage(named: photos[positions[0]].photoName) else { return }
        contentView.imageTapped(cell, indexPath, rightImage, leftImage, photos.count)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Functions
    
    func showPhotos() {
        guard let userResult = user else { return }
        
        let photosResult = realmService.getRealmPhotos(filterKey: userResult.id)
        self.photos = Array(photosResult)
        if photos.count != 0 {
            realmService.setObservePhotosToken(result: photosResult) {
                self.contentView.collectionView.reloadData()
            }
        }
        self.savePhotos(photos.count == 0 ? true : false, userResult)
    }
    
    func savePhotos(_ emptyStorage: Bool,_ userProperty: User) {
        print(albumId, "albumId")
        friendsPhotosService.getFriendsPhotosList(user: userProperty, albumId: self.albumId) { [self] (photosForUpdate) in
            realmService.saveRealmPhotos(photos: photosForUpdate)
            self.photos = photosForUpdate
            if emptyStorage {
                showPhotos()
            }
        }
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
    
    //расчет изображений слайдера
    func nearElements (index: Int) -> [Int]{
        let array = photos
        if array.count == 1 {return [0, 0, 0]}
        if array.count == 2 {
            if index == 0 {
                return [1, index, 1]
            }
            return [0, index, 0]
        }
        if (array.count >= 3) {
            if index == 0 {
                return [array.count - 1, index, 1]
            } else if (index == array.count - 1) {
                return [array.count - 2, index, 0]
            } else {
                return [index - 1, index, index + 1]
            }
        }
        return []
    }
}
