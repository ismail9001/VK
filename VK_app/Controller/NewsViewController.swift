//
//  NewsViewController.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//
// TODO: - сделать раскрытие новостей по кнопке читать далее

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var contentView = self.view as! NewsfeedView
    var news:[News] = []
    var newsService = NewsService()
    let formatter = DateFormatter()
    var imageService = ImageService()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "NewsViewCell", bundle: nil)
        contentView.tableView.register(nib, forCellReuseIdentifier: "NewsViewCell")
        newsService.getNewsList() { news in
            self.news = news
            self.contentView.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let newsCell = news[indexPath.row]
        formatter.dateStyle = .short
        imageService.getImageFromCache(imageName: nil, imageUrl: newsCell.authorPhotoUrl, uiImageView: cell.authorPhoto.avatarPhoto)
        cell.authorName.text = newsCell.authorName
        cell.newsDate.text = formatter.string(from: newsCell.newsDate)
        cell.newsImage.isHidden = false
        cell.newsText.isHidden = false
        switch newsCell.postType {
        case .photo:
            let photoNews = newsCell as! PhotoNews
            imageService.getImageFromCache(imageName: nil, imageUrl: photoNews.newsImageUrl, uiImageView: cell.newsImage)
            cell.newsText.isHidden = true
        case .post:
            let postNews = newsCell as! PostNews
            cell.newsText.text = postNews.newsText
            cell.newsImage.isHidden = true
        }
        cell.photoLike.likeCountLabel.text = newsCell.likeCount.thousands()
        cell.photoLike.commentCount.text = newsCell.commentCount.thousands()
        cell.photoLike.lookUpCount.text = newsCell.lookUpCount.thousands()
        cell.photoLike.shareCount.text = newsCell.shareCount.thousands()
        return cell
    }
}
