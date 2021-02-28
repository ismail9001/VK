//
//  FriendsServiceAdapter.swift
//  VK_app
//
//  Created by macbook on 28.02.2021.
//

import Foundation
import RealmSwift


protocol UpdateViewDelegate: class {
    func updateView(photos: [Photo])
}

final class FriendPhotosAdapter {
    
    private let friendsPhotosService = FriendsPhotosService()
    private let realmService = RealmService()
    private let albumId = 0
    private var photos:[Photo] = []
    weak var updateDelegate : UpdateViewDelegate?
    
    func getPhotos(user: User) {
        let photosResult = realmService.getRealmPhotos(filterKey: user.id)
        photos = Array(photosResult)
        if photos.count != 0 {
            realmService.setObservePhotosToken(result: photosResult) {
                self.updateDelegate?.updateView(photos: self.photos)
            }
        }
        savePhotos(photos.count == 0 ? true : false, user)
    }
    
    private func savePhotos(_ emptyStorage: Bool,_ userProperty: User) {
        friendsPhotosService.getFriendsPhotosList(user: userProperty, albumId: albumId) { [self] (photosForUpdate) in
            realmService.saveRealmPhotos(photos: photosForUpdate)
            photos = photosForUpdate
            if emptyStorage {
                self.getPhotos(user: userProperty)
            }
        }
    }
}

