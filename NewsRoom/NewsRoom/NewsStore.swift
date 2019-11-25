//
//  NewsStore.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

class NewsStore {
    private var latestLanguageNewsMap: [String: ArticleGroup]
    private let queue = DispatchQueue(label: "NewsStoreQueue", attributes: .concurrent)
    
    init(latestLanguageNewsMap: [String: ArticleGroup] = [:]) {
        self.latestLanguageNewsMap = latestLanguageNewsMap
    }
    
    func setArticleGroup(language: Language, articleGroup: ArticleGroup) {
        queue.async(flags: .barrier) { [unowned self] in
            self.latestLanguageNewsMap[language.rawValue] = articleGroup
        }
    }
    
    func getArticleGroup(language: Language) -> ArticleGroup? {
        queue.sync {
            return latestLanguageNewsMap[language.rawValue]
        }
    }
}
