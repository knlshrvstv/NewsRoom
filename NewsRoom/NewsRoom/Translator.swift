//
//  Translator.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/24/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import Utilities

class Translator {
    /**
    Translates an ArticleGroup into a given language

    - Parameters:
     - articleGroup: The ArticleGroup that needs to be translated.
     - langauge: The langauge to which the said ArticleGroup needs to be translated into.

    - Returns: A new and translated ArticleGroup.
    */
    func translate(articleGroup: ArticleGroup, to language: Language) -> ArticleGroup? {
        guard articleGroup.language != language else { return articleGroup }
        var translatedArticles: [Article] = []
        for article in articleGroup.articles {
            let titleTranslation = language.translate(text: article.title)
            var bodyTranslation: String?
            if let body = article.body {
                bodyTranslation = language.translate(text: body)
            }
            
            let translatedArticle = Article(title: titleTranslation,
                                            images: article.images,
                                            body: bodyTranslation)
            translatedArticles.append(translatedArticle)
        }
        
        return ArticleGroup(articles: translatedArticles, language: language)
    }
}
