//
//  Article.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

struct Article: Codable, Equatable {
    let title: String
    let images: [Image]
    let body: String?
    
    struct Image: Codable, Equatable {
        let topImage: Bool
        let url: String?
        let width: Int
        let height: Int
        
        static func ==(lhs: Image, rhs: Image) -> Bool {
            return lhs.topImage == rhs.topImage
                && lhs.url == rhs.url
                && lhs.width == rhs.width
                && lhs.height == rhs.height
        }
    }
    
    static func ==(lhs: Article, rhs: Article) -> Bool {
        return lhs.title == rhs.title
            && lhs.images == rhs.images
            && lhs.body == rhs.body
    }
}
