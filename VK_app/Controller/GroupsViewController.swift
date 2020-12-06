//
//  GroupsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class GroupsViewController: UITableViewController {
    
    var groups:[Group] = []
    
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
        if let data = group.photo {
            cell.groupPhoto.avatarPhoto.image = UIImageView.imageFromData(data: data)
        } else {
            cell.groupPhoto.avatarPhoto.image = UIImage(named: "camera_200")
            cell.groupPhoto.avatarPhoto.load(url: group.photoUrl) {[self] (loadedImage) in
                groups[indexPath.row].photo = loadedImage.pngData()
            }
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
                    // Обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка «Удалить»
        if editingStyle == .delete {
            // Удаляем группу из массива
            groups.remove(at: indexPath.row)
            // И удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
