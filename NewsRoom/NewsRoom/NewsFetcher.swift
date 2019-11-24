//
//  NewsFetcher.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

class NewsFetcher {
    private let newsStore: NewsStore
    private let newsService: NewsService
    private let translator: Translator
    
    init(newsStore: NewsStore = NewsStore(),
         newsService: NewsService = NewsService(),
         translator: Translator = Translator()) {
        self.newsStore = newsStore
        self.newsService = newsService
        self.translator = translator
    }
    
    func fetchArticles(language: Language = .english,
                       successHandler: @escaping (ArticleGroup) -> Void,
                       failureHandler: @escaping (FetchError) -> Void) {
        newsService.fetchArticles(successHandler: { [unowned self] (articles) in
            guard let articleGroup = ArticleGroup(articles: articles, language: .english) else {
                failureHandler(FetchError.data)
                return
            }
            
            self.newsStore.setArticleGroup(language: articleGroup.language, articleGroup: articleGroup)
            
            let requiresTranslation = language != articleGroup.language
            if requiresTranslation {
                self.translate(toLanguage: language, didTranslate: { (group) in
                    self.newsStore.setArticleGroup(language: group.language, articleGroup: articleGroup)
                    successHandler(group)
                }) { (error) in
                    failureHandler(error)
                }
            } else {
                successHandler(articleGroup)
            }
        }) { (error) in
            failureHandler(error)
        }
    }
    
    func translate(toLanguage language: Language,
                   didTranslate: @escaping (ArticleGroup) -> Void,
                   didFailToTranslate: @escaping (FetchError) -> Void) {
        if let articleGroup = newsStore.getArticleGroup(language: language) {
            didTranslate(articleGroup)
        } else if let englishTranslation = newsStore.getArticleGroup(language: .english), let translation = translator.translate(articleGroup: englishTranslation, to: language) {
            newsStore.setArticleGroup(language: language, articleGroup: translation)
            didTranslate(translation)
        } else {
            fetchArticles(successHandler: { [unowned self] (group) in
                guard let translation = self.translator.translate(articleGroup: group, to: language) else {
                    didFailToTranslate(FetchError.data)
                    
                    return
                }
                
                self.newsStore.setArticleGroup(language: language, articleGroup: translation)
            }) { (error) in
                didFailToTranslate(error)
            }
        }
    }
}
