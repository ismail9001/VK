//
//  FriendsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit
import Kingfisher
import RealmSwift

protocol UserUpdatingDelegate: class {
    func updateUser(photos: [Photo], id: Int)
}
protocol LetterPickerDelegate: class {
    func letterPicked(_ letter: String)
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UserUpdatingDelegate, LetterPickerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    var users: [User] = []
    var unfilteredUsers: [User] = []
    var friendsService = FriendService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterPicker.delegate = self
        letterPicker.letters = uniqueLettersCount()
        let headerSection = UINib.init(nibName: "CustomHeaderView", bundle: Bundle.main)
        tableView.register(headerSection, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
        searchBar.placeholder = "Find a friend"
        searchBar.delegate = self
        friendsService.getFriendsList() { [self] (friends) in
            users = friends.sorted{ $0.name.lowercased() < $1.name.lowercased() }
            tableView.reloadData()
            unfilteredUsers = users
            //saveUserData(users)
        }
        showUserData()
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
    
    func uniqueLettersCount () -> [String]{
        let allLetters = users.map { String($0.name.uppercased().prefix(1))}
        letterPicker.letters = Array(Set(allLetters)).sorted()
        return letterPicker.letters
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return uniqueLettersCount().count
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
            if ( String(user.name.first ?? Character("")) == letterPicker.letters[section]) {
                countOfRows += 1
            }
        }
        return countOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsViewCell
        let rowCount = rowCounting(indexPath)
        let user = users[rowCount]
        if let data = user.photo {
            cell.friendPhoto.avatarPhoto.image = UIImageView.imageFromData(data: data)
        }
        else {
            cell.friendPhoto.avatarPhoto.image = UIImage(named: "camera_200")
            cell.friendPhoto.avatarPhoto.load(url: user.photoUrl) {[self] (loadedImage) in
                users[rowCount].photo = cell.friendPhoto.avatarPhoto.image?.pngData()
            }
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
    
    func saveUserData(_ users: [User]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(users)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func showUserData() {
        do {
            let realm = try Realm()
            let users = realm.objects(User.self)
            print(users)
        } catch {
            print(error)
        }
    }
}

