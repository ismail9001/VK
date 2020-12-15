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
    let realm = try! Realm(configuration: Config.realmConfig)
    var token: NotificationToken?
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
                // Добавляем группу в список выбранных  сообществ
                if !groups.contains(group) {
                    groups.append(group)
                    do {
                        realm.beginWrite()
                        
                        group.liked = true
                        
                        try realm.commitWrite()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка «Удалить»
        if editingStyle == .delete {
            // Удаляем группу из массива
            let groupForDelete = groups[indexPath.row]
            do {
                try realm.write{
                    groupForDelete.liked = false
                }
            } catch {
                print(error)
            }
            groups.remove(at: indexPath.row)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGroups()
    }
    
    func showGroups() {
        
        let groups = realm.objects(Group.self)//.sorted(byKeyPath: "title", ascending: true)
        let groupsArray = Array(groups.filter("liked == true"))
        if groupsArray.count != 0 {
            self.groups = groupsArray
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
    }
}
