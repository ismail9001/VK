//
//  FriendsAdapter.swift
//  VK_app
//
//  Created by macbook on 28.02.2021.
//

import Foundation

protocol UpdateFriendsViewProtocol: class {
    func updateView(friends: [User])
}

class FriendsAdapter {
    private let friendsProxyService: FriendsRequestLoggingProxy = {
        let friendService = FriendsService()
        let proxyService = FriendsRequestLoggingProxy(friendService: friendService)
        return proxyService
    }()
    private let realmService = RealmService()
    private let groupsService = GroupsService()
    private var friends:[User] = []
    private var unfilteredUsers: [User] = []
    weak var updateDelegate : UpdateFriendsViewProtocol?
    
    func showFriends() {
        let users =  realmService.getRealmUsers(sortingKey: "name")
        let usersArray = Array(users)
        if usersArray.count != 0 {
            friends = usersArray
            unfilteredUsers = self.friends
            updateDelegate?.updateView(friends: usersArray)
        }
        saveUserData(usersArray.count == 0 ? true : false)
    }
    
    private func saveUserData(_ emptyStorage: Bool) {
        friends = friendsProxyService.getFriendsList()
        if emptyStorage {
            showFriends()
        } else {
            updateDelegate?.updateView(friends: friends)
        }
    }
}
