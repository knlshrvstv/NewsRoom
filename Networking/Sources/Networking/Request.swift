//
//  Request.swift
//  
//
//  Created by Kunal Shrivastava on 11/23/19.
//

import Foundation

protocol Request {
    var url: URL { get }
    var httpVerb: HTTPVerb { get }
    var headerFields: [String: String]? { get }
    var body: Data? { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
}

extension Request {
    var httpVerb: HTTPVerb {
        return .get
    }
    
    var headerFields: [String: String]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
    
    var timeoutInterval: TimeInterval {
        return 60.0
    }
}

/**
Creates an HTTPRequest object

- Parameter url: The URL object that is used to make the HTTP request

- Returns: A HTTPRequest object.
*/
public struct HTTPRequest: Request {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
