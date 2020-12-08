//
//  GroupsSearchViewControllerExtension.swift
//  VK_app
//
//  Created by macbook on 28.11.2020.
//

import UIKit
import RealmSwift

extension GroupsSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText ==  "") {
            groups = unfilteredGroups
            return
        }
        groups = unfilteredGroups.filter{ $0.title.lowercased().contains(searchText.lowercased()) }
        print(groups.count)
        //groupsService.groupsSearch(searchText)
        
        
        //groupsService.getGroupsList() { [self] vkGroups in
        /*    groups = vkGroups.sorted{ $0.title.lowercased() < $1.title.lowercased()}
            do {
                let realm = try Realm(configuration: Config.realmConfig)
                realm.beginWrite()
                realm.add(groups, update: .modified)
                try realm.commitWrite()
                showGroups()
            } catch {
                print(error)
            }
        }*/
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
