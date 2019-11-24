//
//  NewsService.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import Networking

enum FetchError {
    case service
    case data
    case noNetwork
    case unknown
    
    init(serviceError: ServiceError) {
        switch serviceError {
        case .error, .invalidEndpoint, .invalidResponse, .unknownError:
            self = .service
        case .dataDecodeError, .noData:
            self = .data
        case .networkError:
            self = .noNetwork
        }
    }
}

class NewsService {
    private static let endpoint = "https://s1.nyt.com/ios-newsreader/candidates/test/articles.json"
    private let networker: Networker
    
    init(networker: Networker = Networker()) {
        self.networker = networker
    }
    
    func fetchArticles(successHandler: @escaping ([Article]) -> Void,
                       failureHandler: @escaping (FetchError) -> Void) {
        networker.fetchAndDecode(request: HTTPRequest(url: URL(string: NewsService.endpoint)!)) { (result: Result<[Article], ServiceError>) in
            switch result {
            case .success(let articles):
                successHandler(articles)
            case .failure(let error):
                failureHandler(FetchError(serviceError: error))
            }
        }
    }
}
