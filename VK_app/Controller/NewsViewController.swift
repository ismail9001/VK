//
//  NewsViewController.swift
//  VK_app
//
//  Created by macbook on 01.11.2020.
//
// TODO: - сделать раскрытие новостей по кнопке читать далее

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, ShowMoreButtonDelegate {

    lazy var contentView = self.view as! NewsfeedView
    lazy var refreshControl = UIRefreshControl()
    var news:[News] = []
    var newsService = NewsService()
    let newsAdapter = NewsAdapter()
    let formatter = DateFormatter()
    var imageService = ImageService()
    var newsFromTime: Double?
    var isLoading = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "NewsViewCell", bundle: nil)
        contentView.tableView.register(nib, forCellReuseIdentifier: "NewsViewCell")
        formatter.dateStyle = .short
        contentView.tableView.prefetchDataSource = self
        addRefreshControl()
        getNews()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    //TODO: Вынести во View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let newsCell = news[indexPath.row]
        imageService.getImageFromCache(imageName: nil, imageUrl: newsCell.authorPhotoUrl, uiImageView: cell.authorPhoto.avatarPhoto)
        cell.authorName.text = newsCell.authorName
        cell.newsDate.text = formatter.string(from: newsCell.newsDate)
        cell.showMoreButton.isHidden = true
        cell.newsImage.isHidden = false
        cell.newsText.isHidden = false
        switch newsCell.postType {
        case .photo:
            let photoNews = newsCell as! PhotoNews
            imageService.getImageFromCache(imageName: nil, imageUrl: photoNews.newsImageUrl, uiImageView: cell.newsImage)
            cell.newsText.isHidden = true
            let tableWidth = self.contentView.tableView.bounds.width
            let cellHeight = tableWidth * photoNews.aspectRatio!
            cell.imageView_HeightConstraint.constant = cellHeight
            cell.layoutIfNeeded()
        case .post:
            cell.delegate = self
            let postNews = newsCell as! PostNews
            cell.newsText.text = postNews.newsText
            cell.newsImage.isHidden = true
            if cell.newsText.text?.count ?? 0 > 200 {
                cell.showMoreButton.isHidden = false
            }
        }
        cell.photoLike.likeCountLabel.text = newsCell.likeCount.thousands()
        cell.photoLike.commentCount.text = newsCell.commentCount.thousands()
        cell.photoLike.lookUpCount.text = newsCell.lookUpCount.thousands()
        cell.photoLike.shareCount.text = newsCell.shareCount.thousands()
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        
        if maxRow > news.count - 7,
           !isLoading {
            isLoading = true
            newsService.getNewsList(timeFrom: nil) { news in
                var indexPaths:[IndexPath] = []
                for index in self.news.count ..< self.news.count + news.count {
                    indexPaths.append(IndexPath(row: index, section: 0))
                }
                self.news += news
                self.updateTable(indexPaths)
                self.isLoading = false
            }
        }
    }
    
    // MARK: -Functions
    
    func getNews() {
        newsService.getNewsList(timeFrom: newsFromTime) { news in
            var indexPaths:[IndexPath] = []
            for (index, _) in news.enumerated() {
                indexPaths.append(IndexPath(row: index, section: 0))
            }
            self.news = news + self.news
            self.updateTable(indexPaths)
        }
        self.newsFromTime = NSDate().timeIntervalSince1970 + 1
    }
    
    func updateTable(_ indexPaths: [IndexPath]) {
        self.contentView.tableView.beginUpdates()
        self.contentView.tableView.insertRows(at: indexPaths, with: .fade)
        self.contentView.tableView.endUpdates()
    }
    
    func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh news")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        contentView.tableView.addSubview(refreshControl)
        contentView.tableView.sendSubviewToBack(refreshControl)
    }
    
    func resizeImageWithAspect(news: PhotoNews,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        return nil
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.getNews()
            }
        }
        refreshControl.endRefreshing()
    }
    
    // MARK: - ShowMoreButtonDelegate
    func updateTable(_ cell: NewsViewCell) {
        contentView.tableView.beginUpdates()
        cell.expanded.toggle()
        contentView.tableView.endUpdates()
    }
}
