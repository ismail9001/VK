//
//  RealmService.swift
//  VK_app
//
//  Created by macbook on 23.12.2020.
//

import Foundation
import RealmSwift

class RealmService {
    let realm = try! Realm(configuration: Config.realmConfig)
    var userToken: NotificationToken?
    var photoToken: NotificationToken?
    
    func getRealmPhotos(filterKey: Int) -> Results<Photo>{
        let photos = realm.objects(Photo.self).filter("user.id == %@", filterKey)
        return photos
    }
    
    func getRealmGroups(sortingKey: String) -> Results<Group>{
        let groups = realm.objects(Group.self).sorted(byKeyPath: sortingKey, ascending: true)
        return groups
    }
    
    func getRealmUsers(sortingKey: String) -> Results<User>{
        let users = realm.objects(User.self).sorted(byKeyPath: sortingKey, ascending: true)
        return users
    }
    
    func saveRealmUsers(users: [User]) {
        do {
            realm.beginWrite()
            
            let items = users
            let ids = items.map { $0.id }
            let objectsToDelete = realm.objects(User.self).filter("NOT id IN %@", ids)
            realm.delete(objectsToDelete)
            realm.add(users, update: .modified)
            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func saveRealmPhotos(photos: [Photo]) {
        do {
            realm.beginWrite()

            let ids = photos.map { $0.id }
            let objectsToDelete = realm.objects(Photo.self).filter("NOT id IN %@", ids)
            realm.delete(objectsToDelete)
            realm.add(photos, update: .modified)
            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func setObserveToken(result: Results<User>, tableView: UITableView){
        userToken = result.observe{ (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                tableView.reloadData()
            case .update( _, deletions: _, insertions: _, modifications: _):
                tableView.reloadData()
            case .error( let error):
                fatalError("\(error)")
            }
        }
    }
    
    func setObservePhotosToken(result: Results<Photo>, collectionView: UICollectionView){
        photoToken = result.observe{ (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                collectionView.reloadData()
            case .update( _, deletions: _, insertions: _, modifications: _):
                collectionView.reloadData()
            case .error( let error):
                fatalError("\(error)")
            }
        }
    }
}
