//
//  Article.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

struct Article: Codable {
    let title: String
    let images: [Image]
    let body: String?
    
    struct Image: Codable {
        let topImage: Bool
        let url: String?
        let width: Int
        let height: Int
    }
}
