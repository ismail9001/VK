//
//  GroupsSearchViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class GroupsSearchViewController: UITableViewController, UpdateGroupsViewProtocol {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var groups: [Group] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var unfilteredGroups: [Group] = []
    let imageService = ImageService()
    let groupsAdapter = GroupsAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Find a group"
        searchBar.delegate = self
        groupsAdapter.updateDelegate = self
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
        imageService.getImageFromCache(imageName: group.photoName, imageUrl: group.photoUrl, uiImageView: cell.groupPhoto.avatarPhoto)
        cell.groupName.text = group.title
        return cell
    }
    
    func updateView(groups: [Group]) {
        self.groups = groups
    }
}
//for constrait debug
extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
