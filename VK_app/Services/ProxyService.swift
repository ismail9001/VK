//
//  ProxyService.swift
//  VK_app
//
//  Created by macbook on 06.03.2021.
//

import Foundation
import PromiseKit

class FriendsRequestLoggingProxy: FriendsServiceInterface {
    
    let friendService: FriendsService
    
    init(friendService: FriendsService) {
        self.friendService = friendService
    }
    
    func getFriendsList() -> [User] {
        print("called func getFriends")
        return self.friendService.getFriendsList()
    }

}

class FriendsPhotosLoggingProxy: FriendsPhotosServiceInterface {
    
    let friendsPhotosService: FriendsPhotosService
    
    init(friendsPhotosService: FriendsPhotosService) {
        self.friendsPhotosService = friendsPhotosService
    }
    
    func getFriendsPhotosList(user: User, albumId: Int, completion: @escaping ([Photo]) -> Void) {
        friendsPhotosService.getFriendsPhotosList(user: user, albumId: albumId, completion: completion)
        print("called get friend \(user.name) photos request in \(albumId) album's Id")
    }

}

class GroupsRequestLoggingProxy: GroupsServiceInterface {
    
    let groupsService: GroupsService
    
    init(groupsService: GroupsService) {
        self.groupsService = groupsService
    }
    
    func getGroupsList(completion: @escaping ([Group]) -> Promise<[Group]>) {
        groupsService.getGroupsList(completion: completion)
        print("called getGroupsList request")
    }
    
    func groupsSearch(_ search: String) -> Promise<[Group]> {
        print("called searching request with \(search) search text")
        let searchResult = groupsService.groupsSearch(search)
        return searchResult
    }
    
    func joinInGroup(_ groupId: Int) -> Promise<Bool> {
        print("called joinInGroup request with \(groupId) group Id")
        return groupsService.joinInGroup(groupId)
    }
    
    func leaveFromGroup(_ groupId: Int) -> Promise<Bool> {
        print("called leaveFromGroup request with \(groupId) group Id")
        return groupsService.leaveFromGroup(groupId)
    }

}
