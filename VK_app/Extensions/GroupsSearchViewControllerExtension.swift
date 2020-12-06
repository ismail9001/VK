//
//  GroupsSearchViewControllerExtension.swift
//  VK_app
//
//  Created by macbook on 28.11.2020.
//

import UIKit

extension GroupsSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText ==  "") {
            groups = unfilteredGroups
            return
        }
        groups = unfilteredGroups.filter{ $0.title.lowercased().contains(searchText.lowercased()) }
        groupsService.groupsSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        groups = unfilteredGroups
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
     {
        self.dismissKeyboard()
     }
}
