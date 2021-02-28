//
//  NewsFactory.swift
//  VK_app
//
//  Created by macbook on 28.02.2021.
//


import Foundation
import UIKit

struct NewsViewModel {
    let authorName: String
    let authorPhotoUrl: String
    let newsDate: String
    let likeCount: String
    let lookUpCount: String
    let shareCount: String
    let commentCount: String
    let newsImageUrl: String
    let width: Int?
    let height: Int?
    var aspectRatio: CGFloat? { return CGFloat(height!)/CGFloat(width!) }
    var newsText: String?
    
    enum postTypes: String{
        case post
        case photo
    }
    var postType: News.postTypes
}

final class NewsViewModelFactory {
    
    private static let formatter = DateFormatter()
    
    func constructViewModels(from news: [News]) -> [NewsViewModel] {
        return news.compactMap(self.viewModel)
    }
    
    private func viewModel(from news: News) -> NewsViewModel {
        Self.formatter.dateStyle = .short
        let authorName = news.authorName
        let authorPhotoUrl = news.authorPhotoUrl
        let newsDate = Self.formatter.string(from: news.newsDate)
        let likeCount = news.likeCount.thousands()
        let lookUpCount = news.lookUpCount.thousands()
        let shareCount = news.shareCount.thousands()
        let commentCount = news.commentCount.thousands()
        let postType = news.postType
        var width: Int?
        var height: Int?
        var newsImageUrl = ""
        var newsText: String?
        switch news.postType {
        case .photo:
            let photoNews = news as! PhotoNews
            width = photoNews.width
            height = photoNews.height
            newsImageUrl = photoNews.newsImageUrl
        case .post:
            let postNews = news as! PostNews
            newsText = postNews.newsText
            newsImageUrl = postNews.newsImageUrl
        }
        
        return NewsViewModel(authorName: authorName, authorPhotoUrl: authorPhotoUrl, newsDate: newsDate, likeCount: likeCount, lookUpCount: lookUpCount, shareCount: shareCount, commentCount: commentCount, newsImageUrl: newsImageUrl, width: width, height: height, newsText: newsText, postType: postType)
    }
}
