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

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UserUpdatingDelegate, LetterPickerDelegate, RecalculateTableDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    var users: [User] = [] {
        willSet{
            //сохраняем старую структуру данных таблицы
            recalcOldSections()
        }
        didSet{
            unfilteredUsers = users
        }
    }
    
    var newSections = [ViewSection]()
    var oldSections = [ViewSection]()
    
    var oldUsers: [User] = []
    var unfilteredUsers: [User] = []
    var friendsService = FriendService()
    //Firebase
    //let loginService = AuthorizationService()
    let realmService = RealmService()
    lazy var refreshControl = UIRefreshControl()
    var bufferSection:[ViewSection]?
    var firstLoad = true
    
    //TODO: -- refactor viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        letterPicker.delegate = self
        letterPicker.letters = uniqueLettersCount(users: users)
        
        let headerSection = UINib.init(nibName: "CustomHeaderView", bundle: Bundle.main)
        tableView.register(headerSection, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
        searchBar.placeholder = "Find a friend"
        searchBar.delegate = self
        //делегат сравнения структуры
        realmService.recalculateDelegate = self
        
        showUserData()
        addRefreshControl()
        
        //saveUserToFirebase()
    }
    
    // MARK: - Functions
    
    func rowCounting(_ indexPath: IndexPath) -> Int{
        var i = 0
        var rowCount = 0
        while i < indexPath.section {
            rowCount += tableView.numberOfRows(inSection: i)
            i += 1
        }
        rowCount += indexPath.row
        return rowCount
    }
    //подсчет уникальных первых букв в именах
    func uniqueLettersCount (users:[User]) -> [String]{
        let allLetters = users.map { String($0.name.uppercased().prefix(1))}
        letterPicker.letters = Array(Set(allLetters)).sorted()
        return letterPicker.letters
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return uniqueLettersCount(users: self.users).count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        headerView.sectionLabel.text = letterPicker.letters[section]
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfRows = 0
        for user in users {
            if let firstLetter = user.name.first {
                if (String(firstLetter) == letterPicker.letters[section]) {
                    countOfRows += 1
                }
            }
        }
        return countOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsViewCell
        let rowCount = rowCounting(indexPath)
        let user = users[rowCount]
        if let savedImage = UIImageView.getSavedImage(named: user.photoName) {
            cell.friendPhoto.avatarPhoto.image = savedImage
        }
        else {
            cell.friendPhoto.avatarPhoto.image = UIImage(named: "camera_200")
            cell.friendPhoto.avatarPhoto.load(url: user.photoUrl)
        }
        cell.friendName.text = user.name
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? FriendPhotosViewController,
              let indexPath = tableView.indexPathForSelectedRow
        else { return }
        let rowCount = rowCounting(indexPath)
        controller.user = users[rowCount]
        controller.delegate = self
    }
    
    // MARK: - LetterPickerDelegate
    
    func letterPicked(_ letter: String) {
        guard let index = letterPicker.letters.firstIndex(where: {$0.lowercased().prefix(1) == letter.lowercased()}) else { return }
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // MARK: - UserUpdateDelegate
    
    func updateUser(photos: [Photo], id: Int) {
        if let row = users.firstIndex(where: {$0.id == id}) {
            users[row].photos.removeAll()
            photos.forEach{ photo in
                users[row].photos.append(photo)
            }
        }
        if let row = unfilteredUsers.firstIndex(where: {$0.id == id}) {
            unfilteredUsers[row].photos.removeAll()
            photos.forEach{ photo in
                unfilteredUsers[row].photos.append(photo)
            }
        }
    }
    //TODO:-- сделать обновления построчно, а не всю таблицу
    func showUserData() {
        let users =  realmService.getRealmUsers(sortingKey: "name")
        let usersArray = Array(users)
        if usersArray.count != 0 {
            self.users = usersArray
            realmService.setObserveToken(result: users) {
                self.tableView.reloadData()
            }
        }
        self.saveUserData(usersArray.count == 0 ? true : false)
    }
    
    func saveUserData(_ emptyStorage: Bool) {
        users = friendsService.getFriendsList()
            if emptyStorage {
                showUserData()
            }
    }
    
    /*func saveUserToFirebase() {
     loginService.getProfileInfo()
     }*/
    
    func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
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
        let lettersArray = self.uniqueLettersCount(users: users)
        for letter in lettersArray {
            var section = ViewSection(sectionTitle: letter, cells: [], index: lettersArray.firstIndex(of: letter)!)
            var count = 0
            for user in users {
                if user.name.first?.lowercased() == letter.lowercased() {
                    section.cells.append(ViewCell(id: user.id, index: count) )
                    count += 1
                }
            }
            oldSections.append(section)
        }
    }
    
    func tableUpdate(changes: SectionChanges) {
        self.tableView.beginUpdates()
        self.tableView.deleteSections(changes.deletes, with: .fade)
        self.tableView.insertSections(changes.inserts, with: .fade)
        self.tableView.reloadRows(at: changes.updates.reloads, with: .fade)
        self.tableView.insertRows(at: changes.updates.inserts, with: .fade)
        self.tableView.deleteRows(at: changes.updates.deletes, with: .fade)
        self.tableView.endUpdates()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        //Для теста обновления данных
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.saveUserData(self.users.count == 0 ? true : false)
            }
        }
        refreshControl.endRefreshing()
    }
}
