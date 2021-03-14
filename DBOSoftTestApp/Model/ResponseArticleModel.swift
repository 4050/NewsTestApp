//
//  ArticleModel.swift
//  DBOSoftTestApp
//
//  Created by Stanislav on 13.03.2021.
//

import Foundation

struct ResponseModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}


class ResponseArticleModel {
    
    private let networkDataFetch: DataFetcher
    private let imageDownloadService: ImageDownloadProtocol
    
    init(networkDataFetch: DataFetcher, imageDownloadService: ImageDownloadProtocol) {
        self.networkDataFetch = networkDataFetch
        self.imageDownloadService = imageDownloadService
    }
    
    func downloadImage(url: String, completion: @escaping (Data?) -> Void){
        imageDownloadService.fetchImage(urlString: url) { (data) in
            completion(data)
        }
    }
    
    func requestArticle(urlString: String, completion: @escaping (ResponseModel?) -> Void) {
        networkDataFetch.dataAnswerFetch(urlString: urlString) {(response, error) in
            completion(response)
        }
    }
    
    func requestFoundArticles(urlString: String, completion: @escaping (ResponseModel?) -> Void) {
        networkDataFetch.dataAnswerFetch(urlString: urlString) {(response, error) in
            print(response)
            completion(response)
        }
    }
}


