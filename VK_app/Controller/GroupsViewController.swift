//
//  GroupsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import RealmSwift

class GroupsViewController: UITableViewController {
    
    var groups:[Group] = []
    var user:User = User()
    let groupsService = GroupsService()
    let realmService = RealmService()
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
        if let savedImage = UIImageView.getSavedImage(named: group.photoName) {
            cell.groupPhoto.avatarPhoto.image = savedImage
        } else {
            cell.groupPhoto.avatarPhoto.image = UIImage(named: "camera_200")
            cell.groupPhoto.avatarPhoto.load(url: group.photoUrl)
        }
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
                groupsService.joinInGroup(group.id) { [self]response in
                    if response && !groups.contains(group) {
                        //обновляем данные
                        groups.append(group)
                        groups = groups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
                        realmService.addRealmGroup(group: group)
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
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка «Удалить»
        if editingStyle == .delete {
            let groupForDelete = groups[indexPath.row]
            groupsService.leaveFromGroup (groupForDelete.id){ [self]response in
                if response {
                    // Удаляем группу из массива
                    realmService.deleteRealmGroup(group: groupForDelete)
                    groups.remove(at: indexPath.row)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGroups()
    }
    
    
    func showGroups() {
        
        let groups = realmService.getRealmGroups(sortingKey: "title")//realm.objects(Group.self).sorted(byKeyPath: "title", ascending: true)
        let groupsArray = Array(groups)
        if groupsArray.count != 0 {
            self.groups = groupsArray
            realmService.setObserveGroupToken(result: groups) {
                self.tableView.reloadData()
            }
        }
        self.saveGroups(groupsArray.count == 0 ? true : false)
    }
    
    func saveGroups(_ emptyStorage: Bool) {
        groupsService.getGroupsList() { [self] vkGroups in
            groups = vkGroups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
            realmService.saveRealmGroups(groups: groups)
            if emptyStorage {
                showGroups()
            }
        }
    }
    
}
