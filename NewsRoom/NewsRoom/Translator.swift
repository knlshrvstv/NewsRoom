//
//  Translator.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/24/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

class Translator {
    func translate(articleGroup: ArticleGroup, to language: Language) -> ArticleGroup? {
        guard articleGroup.language != language else { return articleGroup }
        // TODO: Implement translation algorithm
        return ArticleGroup(articles: [Article(title: "Marian Title Test", images: [Article.Image(topImage: true, url: "URL", width: 100, height: 100)], body: "Martian Body Test")], language: .martian)
    }
}
