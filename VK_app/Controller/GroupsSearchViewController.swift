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
    var groups: [Group] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var unfilteredGroups: [Group] = []
    let groupsService = GroupsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Find a group"
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
        showGroups()
        saveGroups()
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
        if let data = group.photo {
            cell.groupPhoto.avatarPhoto.image = UIImageView.imageFromData(data: data)
        } else {
            cell.groupPhoto.avatarPhoto.image = UIImage(named: "camera_200")
            cell.groupPhoto.avatarPhoto.load(url: group.photoUrl) {[self] (loadedImage) in
                do {
                    let realm = try Realm(configuration: Config.realmConfig)
                    try! realm.write {
                        groups[indexPath.row].photo = loadedImage.pngData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        cell.groupName.text = group.title
        return cell
    }
    
    func saveGroups() {
        groupsService.getGroupsList() { [self] vkGroups in
            groups = vkGroups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
            do {
                let realm = try Realm(configuration: Config.realmConfig)
                realm.beginWrite()
                realm.add(groups, update: .modified)
                try realm.commitWrite()
                showGroups()
            } catch {
                print(error)
            }
        }
    }
    
    func showGroups() {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            self.groups = Array(groups)
            unfilteredGroups = self.groups
        } catch {
            print(error)
        }
    }
    
    func deleteObjects() {
        do {
            let realm = try! Realm(configuration: Config.realmConfig)
            try! realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}

extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
