//
//  FriendsServiceAdapter.swift
//  VK_app
//
//  Created by macbook on 28.02.2021.
//

import Foundation
import RealmSwift


protocol UpdateViewProtocol: class {
    func updateView(photos: [Photo])
}

final class FriendPhotosAdapter {
    
    private let friendsPhotosProxyService: FriendsPhotosLoggingProxy = {
        let friendsPhotosService = FriendsPhotosService()
        let proxyService = FriendsPhotosLoggingProxy(friendsPhotosService: friendsPhotosService)
        return proxyService
    }()
    private let realmService = RealmService()
    private var albumId = 0
    private var photos:[Photo] = []
    weak var updateDelegate : UpdateViewProtocol?
    
    func getPhotos(user: User, albumId: Int) {
        self.albumId = albumId
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
        friendsPhotosProxyService.getFriendsPhotosList(user: userProperty, albumId: albumId) { [weak self] (photosForUpdate) in
            self?.realmService.saveRealmPhotos(photos: photosForUpdate)
            self?.photos = photosForUpdate
            if emptyStorage {
                self?.getPhotos(user: userProperty, albumId: self?.albumId ?? 0)
            }
        }
    }
}

