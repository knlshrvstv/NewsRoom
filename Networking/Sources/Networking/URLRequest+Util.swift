//
//  URLRequest+Util.swift
//  
//
//  Created by Kunal Shrivastava on 11/23/19.
//

import Foundation

extension URLRequest {
    init(_ request: HTTPRequest) {
        self.init(url: request.url)
        httpMethod = request.httpVerb.rawValue
        allHTTPHeaderFields = request.headerFields
        httpBody = request.body
    }
}
