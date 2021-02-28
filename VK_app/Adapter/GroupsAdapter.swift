//
//  GroupsAdapter.swift
//  VK_app
//
//  Created by macbook on 28.02.2021.
//

import Foundation
import PromiseKit

protocol UpdateGroupsViewProtocol: class {
    func updateView(groups: [Group])
}

class GroupsAdapter {
    
    private let friendsPhotosService = FriendsPhotosService()
    private let realmService = RealmService()
    private let groupsService = GroupsService()
    private var groups:[Group] = []
    weak var updateDelegate : UpdateGroupsViewProtocol?
    
    func showGroups() {
        let groups = realmService.getRealmGroups(sortingKey: "title")
        let groupsArray = Array(groups)
        if groupsArray.count != 0 {
            self.groups = groupsArray
            self.updateDelegate?.updateView(groups: groupsArray)
        }
        self.saveGroupsInRealm(groupsArray.count == 0 ? true : false)
    }
    
    func groupsSearch(_ searchText: String) {
        groupsService.groupsSearch(searchText)
            .get { [self] vkGroups in
                updateDelegate?.updateView(groups: vkGroups)
        }
    }
    
    func joinInGroup(groups: [Group],joinIn group: Group) {
        self.groups = groups
        groupsService.joinInGroup(group.id)
            .get { [self]response in
                if response && !self.groups.contains(group) {
                    //обновляем данные
                    self.groups.append(group)
                    self.groups = self.groups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
                    //FireStorm
                    /*let groupJSON: [String: Any] = {
                     return [
                     "id": group.id,
                     "name": group.title
                     ]
                     }()
                     let user_id = Config.user_id_firebase
                     Config.db.collection("users").document("\(user_id)").collection("groups").document("\(group.id)") .setData(groupJSON) { error in
                     if let error = error {
                     print("Error adding user: \(error)")
                     } else {
                     print("User updated with ID:\(user_id)")
                     }
                     }*/
                }
            }
            .done{[self] _ in
                self.realmService.saveRealmGroups(groups: self.groups)
                updateDelegate?.updateView(groups: self.groups)
            }
            .catch{[self] error in
                self.groups = []
            }
    }
    
    func exitFromGroup(userGroups: [Group], groupForDelete: Group, groupIndex: Int) {
        self.groups = userGroups
        groupsService.leaveFromGroup (groupForDelete.id)
            .get { [self]response in
                if response {
                    // Удаляем группу из массива
                    self.groups.remove(at: groupIndex)
                    realmService.deleteRealmGroup(group: groupForDelete)
                }
            }
            .done{[self] _ in
                updateDelegate?.updateView(groups: self.groups)
            }
            .catch{[self] error in
                groups = []
            }
    }
    
    private func saveGroupsInRealm(_ emptyStorage: Bool) {
        groupsService.getGroupsList(){[self]vkGroups in
            groups = vkGroups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
            realmService.saveRealmGroups(groups: groups)
            if emptyStorage {
                self.updateDelegate?.updateView(groups: groups)
            }
            let (promise, resolver) = Promise<[Group]>.pending()
            resolver.fulfill(groups)
            return promise
        }
    }
}
