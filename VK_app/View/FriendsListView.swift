//
//  FriendListView.swift
//  VK_app
//
//  Created by macbook on 27.01.2021.
//

import UIKit

final class FriendsListView: UIView, UISearchBarDelegate, LetterPickerDelegate {
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.placeholder = "Find a friend"
        let headerSection = UINib.init(nibName: "CustomHeaderView", bundle: Bundle.main)
        tableView.register(headerSection, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        letterPicker.delegate = self
    }
    
    // MARK: - LetterPickerDelegate
    
    func letterPicked(_ letter: String) {
        guard let index = letterPicker.letters.firstIndex(where: {$0.lowercased().prefix(1) == letter.lowercased()}) else { return }
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
