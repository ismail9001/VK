//
//  FriendsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import Kingfisher

protocol UserUpdatingDelegate: class {
    func updateUser(photos: [Photo], id: Int)
}
protocol LetterPickerDelegate: class {
    func letterPicked(_ letter: String)
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UserUpdatingDelegate, RecalculateTableDelegate, UpdateFriendsViewProtocol {
    
    var friends: [User] = [] {
        willSet{
            //сохраняем старую структуру данных таблицы
            recalcOldSections()
        }
    }
    lazy var contentView = self.view as! FriendsListView
    var newSections = [ViewSection]()
    var oldSections = [ViewSection]()
    var oldUsers: [User] = []
    var unfilteredUsers: [User] = []
    var imageService = ImageService()
    let friendsAdapter = FriendsAdapter()
    //Firebase
    //let loginService = AuthorizationService()
    let realmService = RealmService()
    lazy var refreshControl = UIRefreshControl()
    var bufferSection:[ViewSection]?
    
    //TODO: -- refactor viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.letterPicker.letters = uniqueLettersCount(users: friends)
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
        contentView.searchBar.delegate = self
        //делегат сравнения структуры
        realmService.recalculateDelegate = self
        friendsAdapter.updateDelegate = self
        friendsAdapter.showFriends()
        addRefreshControl()
    }
    
    // MARK: - Functions
    
    func rowCounting(_ indexPath: IndexPath) -> Int{
        var i = 0
        var rowCount = 0
        while i < indexPath.section {
            rowCount += contentView.tableView.numberOfRows(inSection: i)
            i += 1
        }
        rowCount += indexPath.row
        return rowCount
    }
    //подсчет уникальных первых букв в именах
    func uniqueLettersCount (users:[User]) -> [String]{
        let allLetters = users.map { String($0.name.uppercased().prefix(1))}
        contentView.letterPicker.letters = Array(Set(allLetters)).sorted()
        return contentView.letterPicker.letters
    }
    
    // MARK: - TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return uniqueLettersCount(users: self.friends).count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        headerView.sectionLabel.text = contentView.letterPicker.letters[section]
        headerView.sectionLabel.backgroundColor = .systemGray5
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfRows = 0
        for user in friends {
            if let firstLetter = user.name.first {
                if (String(firstLetter) == contentView.letterPicker.letters[section]) {
                    countOfRows += 1
                }
            }
        }
        return countOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsViewCell
        let friendIndex = rowCounting(indexPath)
        let user = friends[friendIndex]
        imageService.getImageFromCache(imageName: user.photoName, imageUrl: user.photoUrl, uiImageView: cell.friendPhoto.avatarPhoto)
        cell.friendName.text = user.name
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? FriendAlbumController,
              let indexPath = contentView.tableView.indexPathForSelectedRow
        else { return }
        let rowCount = rowCounting(indexPath)
        controller.user = friends[rowCount]
    }
    
    // MARK: - UserUpdateDelegate
    
    func updateUser(photos: [Photo], id: Int) {
        if let row = friends.firstIndex(where: {$0.id == id}) {
            friends[row].photos.removeAll()
            photos.forEach{ photo in
                friends[row].photos.append(photo)
            }
        }
        if let row = unfilteredUsers.firstIndex(where: {$0.id == id}) {
            unfilteredUsers[row].photos.removeAll()
            photos.forEach{ photo in
                unfilteredUsers[row].photos.append(photo)
            }
        }
    }
    
    func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        contentView.tableView.addSubview(refreshControl)
        contentView.tableView.sendSubviewToBack(refreshControl)
    }
    
    func recalculateTable(collection: [User]) {
        //новый массив данных для ячеек
        newSections.removeAll()
        let lettersArray = self.uniqueLettersCount(users: collection)
        for letter in lettersArray {
            var section = ViewSection(sectionTitle: letter, cells: [], index: lettersArray.firstIndex(of: letter)!)
            var count = 0
            for user in collection {
                if user.name.first?.lowercased() == letter.lowercased() {
                    section.cells.append(ViewCell(id: user.id, index: count) )
                    count += 1
                }
            }
            newSections.append(section)
        }
        //инициализация обектов изменений
        let sectionChanges = SectionChanges()
        let cellChanges = CellChanges()
        
        let uniqueSectionKeys = (newSections + oldSections)
            .map { $0.sectionTitle }
            .filterDuplicates().sorted()
        //сравнительный перебор по структурам
        for sectionKey in uniqueSectionKeys {
            let oldSectionItem = ReloadableSectionData(items: oldSections)[sectionKey]
            let newSectionItem = ReloadableSectionData(items: newSections)[sectionKey]
            if let oldSectionItem = oldSectionItem, let newSectionItem = newSectionItem {
                if oldSectionItem != newSectionItem {
                    let oldCellIData = ReloadableCellData(items: oldSectionItem.cells)
                    let newCellData = ReloadableCellData(items: newSectionItem.cells)
                    let uniqueCellKeys = (oldCellIData.items + newCellData.items)
                        .map { $0.id }
                        .filterDuplicates()
                    for cellKey in uniqueCellKeys {
                        let oldCellItem = oldCellIData[cellKey]
                        let newCellItem = newCellData[cellKey]
                        if let oldCellItem = oldCellItem, let newCelItem = newCellItem {
                            if oldCellItem != newCelItem {
                                cellChanges.reloads.append(IndexPath(row: oldCellItem.index, section: oldSectionItem.index))
                            }
                        } else if let oldCellItem = oldCellItem {
                            cellChanges.deletes.append(IndexPath(row: oldCellItem.index, section: oldSectionItem.index))
                        } else if let newCellItem = newCellItem {
                            cellChanges.inserts.append(IndexPath(row: newCellItem.index, section: newSectionItem.index))
                        }
                    }
                }
            } else if let oldSectionItem = oldSectionItem {
                sectionChanges.deletesInts.append(oldSectionItem.index)
            } else if let newSectionItem = newSectionItem {
                sectionChanges.insertsInts.append(newSectionItem.index)
            }
        }
        sectionChanges.updates = cellChanges
        tableUpdate(changes: sectionChanges)
    }
    
    func recalcOldSections() {
        //массив структуры учтаревших ячеек
        oldSections.removeAll()
        let lettersArray = self.uniqueLettersCount(users: friends)
        for letter in lettersArray {
            var section = ViewSection(sectionTitle: letter, cells: [], index: lettersArray.firstIndex(of: letter)!)
            var count = 0
            for user in friends {
                if user.name.first?.lowercased() == letter.lowercased() {
                    section.cells.append(ViewCell(id: user.id, index: count) )
                    count += 1
                }
            }
            oldSections.append(section)
        }
    }
    
    func tableUpdate(changes: SectionChanges) {
        self.contentView.tableView.beginUpdates()
        self.contentView.tableView.deleteSections(changes.deletes, with: .fade)
        self.contentView.tableView.insertSections(changes.inserts, with: .fade)
        self.contentView.tableView.reloadRows(at: changes.updates.reloads, with: .fade)
        self.contentView.tableView.insertRows(at: changes.updates.inserts, with: .fade)
        self.contentView.tableView.deleteRows(at: changes.updates.deletes, with: .fade)
        self.contentView.tableView.endUpdates()
    }
    
    func updateView(friends: [User]) {
        self.friends = friends
        self.unfilteredUsers = self.friends
        self.contentView.tableView.reloadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        //Для теста обновления данных
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.friendsAdapter.showFriends()
            }
        }
        refreshControl.endRefreshing()
    }
}
