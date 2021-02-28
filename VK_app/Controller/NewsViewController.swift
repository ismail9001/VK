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
    var imageService = ImageService()
    var newsFromTime: Double?
    var isLoading = false
    private let viewModelFactory = NewsViewModelFactory()
    private var viewModels: [NewsViewModel] = []
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "NewsViewCell", bundle: nil)
        contentView.tableView.register(nib, forCellReuseIdentifier: "NewsViewCell")
        contentView.tableView.prefetchDataSource = self
        viewModels = self.viewModelFactory.constructViewModels(from: news)
        addRefreshControl()
        getNews()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    //TODO: Вынести во View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let newsModel = viewModels[indexPath.row]
        imageService.getImageFromCache(imageName: nil, imageUrl: newsModel.authorPhotoUrl, uiImageView: cell.authorPhoto.avatarPhoto)
        cell.authorName.text = newsModel.authorName
        cell.newsDate.text = newsModel.newsDate
        cell.showMoreButton.isHidden = true
        cell.newsImage.isHidden = false
        cell.newsText.isHidden = false
        switch newsModel.postType {
        case .photo:
            imageService.getImageFromCache(imageName: nil, imageUrl: newsModel.newsImageUrl, uiImageView: cell.newsImage)
            cell.newsText.isHidden = true
            let tableWidth = self.contentView.tableView.bounds.width
            let cellHeight = tableWidth * newsModel.aspectRatio!
            cell.imageView_HeightConstraint.constant = cellHeight
            cell.layoutIfNeeded()
        case .post:
            cell.delegate = self
            cell.newsText.text = newsModel.newsText
            cell.newsImage.isHidden = true
            if cell.newsText.text?.count ?? 0 > 200 {
                cell.showMoreButton.isHidden = false
            }
        }
        cell.photoLike.likeCountLabel.text = newsModel.likeCount
        cell.photoLike.commentCount.text = newsModel.commentCount
        cell.photoLike.lookUpCount.text = newsModel.lookUpCount
        cell.photoLike.shareCount.text = newsModel.shareCount
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        
        if maxRow > viewModels.count - 7,
           !isLoading {
            isLoading = true
            newsService.getNewsList(timeFrom: nil) { news in
                var indexPaths:[IndexPath] = []
                for index in self.news.count ..< self.news.count + news.count {
                    indexPaths.append(IndexPath(row: index, section: 0))
                }
                self.news += news
                self.viewModels = self.viewModelFactory.constructViewModels(from: self.news)
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
            self.viewModels = self.viewModelFactory.constructViewModels(from: self.news)
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
