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
    
    private let realmService = RealmService()
    private let groupsProxyService: GroupsRequestLoggingProxy = {
        let groupsService = GroupsService()
        let proxyService = GroupsRequestLoggingProxy(groupsService: groupsService)
        return proxyService
    }()
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
        groupsProxyService.groupsSearch(searchText)
            .get { [weak self] vkGroups in
                self?.updateDelegate?.updateView(groups: vkGroups)
            }
            .catch{[weak self] error in
                self?.groups = []
            }
    }
    
    func joinInGroup(groups: [Group],joinIn group: Group) {
        self.groups = groups
        groupsProxyService.joinInGroup(group.id)
            .get { [weak self]response in
                if response && !(self?.groups.contains(group) ?? true) {
                    //обновляем данные
                    self?.groups.append(group)
                    self?.groups = self?.groups.sorted{ $0.title.lowercased() < $1.title.lowercased()} ?? []
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
            .done{[weak self] _ in
                self?.realmService.saveRealmGroups(groups: self?.groups ?? [])
                self?.updateDelegate?.updateView(groups: self?.groups ?? [])
            }
            .catch{[weak self] error in
                self?.groups = []
            }
    }
    
    func exitFromGroup(userGroups: [Group], groupForDelete: Group, groupIndex: Int) {
        self.groups = userGroups
        groupsProxyService.leaveFromGroup (groupForDelete.id)
            .get { [weak self]response in
                if response {
                    // Удаляем группу из массива
                    self?.groups.remove(at: groupIndex)
                    self?.realmService.deleteRealmGroup(group: groupForDelete)
                }
            }
            .done{[weak self] _ in
                self?.updateDelegate?.updateView(groups: self?.groups ?? [])
            }
            .catch{[weak self] error in
                self?.groups = []
            }
    }
    
    private func saveGroupsInRealm(_ emptyStorage: Bool) {
        groupsProxyService.getGroupsList(){[self]vkGroups in
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
