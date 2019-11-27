//
//  ArticleDetailViewModel.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/26/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import LazyResourceFetcher

class ArticleDetailViewModel {
    let article: Article
    let resourceFetcher: LazyResourceFetcher
    
    
    init(article: Article,
         resourceFetcher: LazyResourceFetcher) {
        self.article = article
        self.resourceFetcher = resourceFetcher
    }
}
