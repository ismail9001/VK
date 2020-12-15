//
//  GroupsSearchViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import RealmSwift

class GroupsSearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var groups: [Group] = []
    var unfilteredGroups: [Group] = []
    let groupsService = GroupsService()
    let realm = try! Realm(configuration: Config.realmConfig)
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Find a group"
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
        showGroups()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        view.translatesAutoresizingMaskIntoConstraints = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupsViewCell
        let group = groups[indexPath.row]
        
        if let savedImage = UIImageView.getSavedImage(named: group.photoName) {
            cell.groupPhoto.avatarPhoto.image = savedImage
        } else {
            cell.groupPhoto.avatarPhoto.image = UIImage(named: "camera_200")
            cell.groupPhoto.avatarPhoto.load(url: group.photoUrl)
        }
        
        cell.groupName.text = group.title
        return cell
    }
    
    func showGroups() {
        
        let groups = realm.objects(Group.self).sorted(byKeyPath: "title", ascending: true)
        let groupsArray = Array(groups)
        if groupsArray.count != 0 {
            self.groups = groupsArray
            unfilteredGroups = self.groups
            self.token = groups.observe{ (changes: RealmCollectionChange) in
                switch changes {
                case .initial(_):
                    self.tableView.reloadData()
                case .update( _, deletions: _, insertions: _, modifications: _):
                    self.tableView.reloadData()
                case .error( let error):
                    fatalError("\(error)")
                }
            }
        }
        self.saveGroups(groupsArray.count == 0 ? true : false)
    }
    
    func saveGroups(_ emptyStorage: Bool) {
        groupsService.getGroupsList() { [self] vkGroups in
            groups = vkGroups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
            do {
                realm.beginWrite()
                
                let items = groups
                let ids = items.map { $0.id }
                let objectsToDelete = realm.objects(Group.self).filter("NOT id IN %@", ids)
                realm.delete(objectsToDelete)
                realm.add(groups, update: .modified)
                
                try realm.commitWrite()
            } catch {
                print(error)
            }
            if emptyStorage {
                showGroups()
            }
        }
    }
}

extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
