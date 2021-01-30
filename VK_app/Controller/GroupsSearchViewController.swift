//
//  GroupsSearchViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class GroupsSearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var groups: [Group] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var unfilteredGroups: [Group] = []
    let groupsService = GroupsService()
    var imageService = ImageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Find a group"
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
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
        imageService.getImageFromCache(imageName: group.photoName, imageUrl: group.photoUrl)
        cell.groupPhoto.avatarPhoto.image = imageService.image
        cell.groupName.text = group.title
        return cell
    }
}
//for constrait debug
extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
