//
//  ArticleGroup.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

struct ArticleGroup {
    let articles: [Article]
    let language: Language
    
    var count: Int {
        return articles.count
    }
    
    subscript(i: Int) -> Article? {
        guard i < articles.count else { return nil }
        
        return articles[i]
    }
    
    init?(articles: [Article], language: Language) {
        guard articles.isEmpty == false else { return nil }
        self.articles = articles
        self.language = language
    }
}
