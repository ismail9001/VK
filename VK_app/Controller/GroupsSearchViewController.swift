//
//  GroupsSearchViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class GroupsSearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var groups: [Group] = []
    var unfilteredGroups: [Group] = []
    let groupsService = GroupsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Find a group"
        searchBar.delegate = self
        unfilteredGroups = groups
        self.hideKeyboardWhenTappedAround()
        groupsService.getGroupsList() { [self] vkGroups in
            groups = vkGroups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
            self.tableView.reloadData()
            unfilteredGroups = groups
        }
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
                groups[indexPath.row].photo = loadedImage.pngData()
            }
        }
        cell.groupName.text = group.title
        return cell
    }
}

extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
