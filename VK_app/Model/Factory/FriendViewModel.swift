//
//  FriendViewModel.swift
//  VK_app
//
//  Created by macbook on 28.02.2021.
//

import Foundation

struct FriendViewModel {
    let userName: String
    let photoName: String
    let photoUrl: String
}


final class FriendViewModelFactory {
    
    func constructViewModels(from friends: [User]) -> [FriendViewModel] {
        return friends.compactMap(self.viewModel)
    }
    
    private func viewModel(from friend: User) -> FriendViewModel {
        
        let userName = friend.name
        let photoName = friend.photoName
        let photoUrl = friend.photoUrl
        
        return FriendViewModel(userName: userName, photoName: photoName, photoUrl: photoUrl)
    }
}
