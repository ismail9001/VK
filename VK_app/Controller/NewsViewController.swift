//
//  NewsViewController.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var news:[News] = []
    var newsService = NewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "NewsViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NewsViewCell")
        newsService.getNewsList() { news in
            self.news = news
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let newsCell = news[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        cell.authorPhoto.image = UIImage(named: "camera_200")
        cell.authorPhoto.avatarPhoto.load(url: newsCell.authorPhotoUrl)
        
        cell.authorName.text = newsCell.authorName
        cell.newsDate.text = formatter.string(from: newsCell.newsDate)
        cell.newsImage.isHidden = false
        cell.newsText.isHidden = false
        switch newsCell.postType {
        case .photo:
            let photoNews = newsCell as! PhotoNews
            cell.newsImage.load(url: photoNews.newsImageUrl)
            cell.newsText.isHidden = true
        case .post:
            let postNews = newsCell as! PostNews
            cell.newsText.text = postNews.newsText
            cell.newsImage.isHidden = true
        }
        cell.photoLike.likeCount = newsCell.likeCount
        cell.photoLike.commentCount.text = newsCell.commentCount.thousands()
        cell.photoLike.lookUpCount.text = newsCell.lookUpCount.thousands()
        cell.photoLike.shareCount.text = newsCell.shareCount.thousands()
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
