//
//  ArticlesViewModel.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import Utilities

extension UserDefaults.Key {
    static var langaugeSelection: UserDefaults.Key<String> {
        return .init(name: "langaugeSelection")
    }
}

class ArticlesViewModel {
    private let newsFetcher: NewsFetcher
    private var articleGroup: ArticleGroup?
    private let userDefaults: UserDefaults
    
    var language: Language {
        guard let userLanguage = userDefaults[.langaugeSelection] else {
            return .english
        }
        
        return Language(rawValue: userLanguage) ?? .english
    }
    
    init(newsFetcher: NewsFetcher = NewsFetcher(),
         userDefaults: UserDefaults = .standard) {
        self.newsFetcher = newsFetcher
        self.userDefaults = userDefaults
    }
    
    func loadArticles(didLoad: @escaping () -> Void,
                      didFailToLoad: @escaping (FetchError) -> Void) {
        newsFetcher.fetchArticles(language: language,
                                  successHandler: { (articleGroup) in
            self.articleGroup = articleGroup
            didLoad()
        }) { (error) in
            // display error
            didFailToLoad(error)
        }
    }
    
    func translate(to language: Language,
                   didTranslate: @escaping () -> Void,
                   didFailToTranslate: @escaping (FetchError) -> Void) {
        userDefaults[.langaugeSelection] = language.rawValue
        newsFetcher.translate(toLanguage: language, didTranslate: { (articleGroup) in
            self.articleGroup = articleGroup
            didTranslate()
        }) { (error) in
            didFailToTranslate(error)
        }
    }
    
    func numberOfRows() -> Int {
        guard let articleGroup = articleGroup else { return 0 }
        
        return articleGroup.count
    }
    
    func article(_ indexPath: IndexPath) -> Article? {
        guard let articleGroup = articleGroup else { return nil }
        
        return articleGroup[indexPath.row]
    }
}
