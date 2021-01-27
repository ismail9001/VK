//
//  FriendsViewControllerExtension.swift
//  VK_app
//
//  Created by macbook on 28.11.2020.
//

import UIKit

extension FriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText ==  "") {
            friends = unfilteredUsers
            return
        }
        friends = unfilteredUsers.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
        let allLetters = friends.map { String($0.name.uppercased().prefix(1))}
        contentView.letterPicker.letters = Array(Set(allLetters)).sorted()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        friends = unfilteredUsers
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
     {
        self.dismissKeyboard()
     }
}
