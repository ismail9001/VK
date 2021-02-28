//
//  GroupsViewFactory.swift
//  VK_app
//
//  Created by macbook on 28.02.2021.
//

import Foundation

struct GroupViewModel {
    let groupTitle: String
    let photoName: String
    let photoUrl: String
}

final class GroupViewModelFactory {
    
    func constructViewModels(from groups: [Group]) -> [GroupViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: Group) -> GroupViewModel {
        
        let groupTitle = group.title
        let photoName = group.photoName
        let photoUrl = group.photoUrl
        
        return GroupViewModel(groupTitle: groupTitle, photoName: photoName, photoUrl: photoUrl)
    }
}
