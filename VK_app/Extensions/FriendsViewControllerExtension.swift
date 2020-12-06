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
            users = unfilteredUsers
            return
        }
        users = unfilteredUsers.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
        let allLetters = users.map { String($0.name.uppercased().prefix(1))}
        letterPicker.letters = Array(Set(allLetters)).sorted()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        users = unfilteredUsers
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
     {
        self.dismissKeyboard()
     }
}
