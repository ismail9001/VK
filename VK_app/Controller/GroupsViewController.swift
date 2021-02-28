//
//  GroupsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import RealmSwift

class GroupsViewController: UITableViewController, UpdateGroupsViewProtocol {
    
    
    var groups:[Group] = []
    var user:User = User()
    var imageService = ImageService()
    let groupsAdapter = GroupsAdapter()
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
        cell.groupName.text = group.title
        imageService.getImageFromCache(imageName: group.photoName, imageUrl: group.photoUrl, uiImageView: cell.groupPhoto.avatarPhoto)
        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let groupSearchController = segue.source as! GroupsSearchViewController
            // Получаем индекс выделенной ячейки
            if let indexPath = groupSearchController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = groupSearchController.groups[indexPath.row]
                groupsAdapter.joinInGroup(groups: groups, joinIn: group)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка «Удалить»
        if editingStyle == .delete {
            let groupForDelete = groups[indexPath.row]
            groupsAdapter.exitFromGroup(userGroups: groups, groupForDelete: groupForDelete, groupIndex: indexPath.row)
            /*groupsService.leaveFromGroup (groupForDelete.id)
             .get { [self]response in
             if response {
             // Удаляем группу из массива
             realmService.deleteRealmGroup(group: groupForDelete)
             }
             }
             .done{[self] _ in
             groups.remove(at: indexPath.row)
             }
             .catch{[self] error in
             groups = []
             }*/
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsAdapter.updateDelegate = self
        groupsAdapter.showGroups()
    }
    
    func updateView(groups: [Group]) {
        self.groups = groups
        self.tableView.reloadData()
    }
}
