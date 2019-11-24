//
//  HTTPVerb.swift
//  
//
//  Created by Kunal Shrivastava on 11/23/19.
//

import Foundation

/**
Enumeration of supported HTTP verbs
 
[Wikipedia page on HTTP request verbs](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)
*/
public enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
