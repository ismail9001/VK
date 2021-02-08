//
//  FriendAlbumController.swift
//  VK_app
//
//  Created by macbook on 07.02.2021.
//

import UIKit

class FriendAlbumController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    //lazy var contentView = self.view as! FriendsPhotosView
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellIndent: CGFloat = 20
    var albums : [Album] = []
    var user : User?
    var albumId = 0
    //weak var delegate : UserUpdatingDelegate?
    //let realmService = RealmService()
    let imageService = ImageService()
    let albumService = FriendsAlbumService()
    
    //MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Albums"
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
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendsAlbumViewCell
        let album = albums[indexPath.row]
        imageService.getImageFromCache(imageName: nil, imageUrl: album.albumPhotoURL, uiImageView: cell.albumPhoto)
        cell.title.text = album.title
        cell.fotoCount.text = "\(album.size) фотографий"
        //cell.photoLike.liked = photos[indexPath.row].liked
        //cell.photoLike.likeCount = photos[indexPath.row].likes
        //cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        albumId = albums[indexPath.row].id
        print("celselectedl", indexPath)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? FriendPhotosViewController,
              let indexPath = collectionView.indexPathsForSelectedItems
        else { return }
        print(indexPath, "hhh")
        controller.user = user
        controller.albumId = albums[indexPath[0].row].id
    }
    
    //MARK: - Functions
    
    func showPhotos() {
        guard let userResult = user else { return }
        albumService.getFriendsAlbumsList(user: userResult) { albums in
            self.albums = albums
            self.collectionView.reloadData()
        }
    }
}
