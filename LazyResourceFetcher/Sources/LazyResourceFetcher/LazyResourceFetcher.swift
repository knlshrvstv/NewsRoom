//
//  LazyResourceFetcher.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/25/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import Cache

public struct Identifier: Hashable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}

public enum State {
    case notFetching
    case fetching
}

public enum Source: Equatable {
    case cache
    case service
    
    public static func ==(lhs: Source, rhs: Source) -> Bool {
        switch (lhs, rhs) {
        case (.cache, .cache):
            return true
        case (.service, .service):
            return true
        default:
            return false
        }
    }
}

public protocol LazyResourceFetchable {    
    func request(resourceFor identifier: Identifier,
                 completionHandler: @escaping (Data, Source, Identifier) -> Void)
    func cancelRequest(for identifier: Identifier)
    func cancelAllRequests()
    func state(of identifier: Identifier) -> State
}

public class LazyResourceFetcher {
    private let queue: OperationQueue
    private var operationsMap = [Identifier: Operation]()
    private let cache: Cache<URL, Data>

    public init(queue: OperationQueue = OperationQueue(),
                cache: Cache<URL, Data> = Cache<URL, Data>()) {
        self.queue = queue
        self.cache = cache
    }
}

extension LazyResourceFetcher: LazyResourceFetchable {
    public func request(resourceFor identifier: Identifier,
                 completionHandler: @escaping (Data, Source, Identifier) -> Void) {
        if let cachedData = cache[identifier.url] {
            print("cache hit")
            completionHandler(cachedData, .cache, identifier)
            
            return
        }
        
        if state(of: identifier) == .fetching {
            return
        }
        
        let operation = ResourceFetchOperation(resourceURL: identifier.url) { [unowned self] (data) in
            self.operationsMap.removeValue(forKey: identifier)
            self.cache[identifier.url] = data
            completionHandler(data, .service, identifier)
        }
        
        operationsMap[identifier] = operation
        
        queue.addOperation(operation)
    }
    
    public func cancelRequest(for identifier: Identifier) {
        operationsMap[identifier]?.cancel()
        operationsMap.removeValue(forKey: identifier)
    }
    
    public func cancelAllRequests() {
        queue.cancelAllOperations()
        operationsMap.removeAll()
    }
    
    public func state(of identifier: Identifier) -> State {
        return operationsMap[identifier] != nil ? State.fetching : State.notFetching
    }
}
