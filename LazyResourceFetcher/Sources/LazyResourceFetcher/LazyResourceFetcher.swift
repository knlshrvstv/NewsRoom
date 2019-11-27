//
//  LazyResourceFetcher.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/25/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation
import Cache

public struct Identifier<T: Hashable>: Hashable {
    public let id: T
    public let url: URL
    
    public init(id: T, url: URL) {
        self.id = id
        self.url = url
    }
}

public enum State {
    case notFetching
    case fetching
}

public protocol LazyResourceFetchable {
    associatedtype T: Hashable
    
    func request(resourceFor identifier: Identifier<T>,
                 completionHandler: @escaping (Data) -> Void)
    func cancelRequest(for identifier: Identifier<T>)
    func cancelAllRequests()
    func state(of identifier: Identifier<T>) -> State
}

public class LazyResourceFetcher<T: Hashable> {
    private let queue: OperationQueue
    private var operationsMap = [Identifier<T>: Operation]()
    private let cache: Cache<URL, Data>

    public init(queue: OperationQueue = OperationQueue(),
                cache: Cache<URL, Data> = Cache<URL, Data>()) {
        self.queue = queue
        self.cache = cache
    }
}

extension LazyResourceFetcher: LazyResourceFetchable {
    public func request(resourceFor identifier: Identifier<T>,
                 completionHandler: @escaping (Data) -> Void) {
        if let cachedData = cache[identifier.url] {
            completionHandler(cachedData)
            
            return
        }
        
        let operation = ResourceFetchOperation(resourceURL: identifier.url) { [unowned self] (data) in
            self.operationsMap.removeValue(forKey: identifier)
            self.cache[identifier.url] = data
            completionHandler(data)
        }
        
        operationsMap[identifier] = operation
        
        queue.addOperation(operation)
    }
    
    public func cancelRequest(for identifier: Identifier<T>) {
        operationsMap[identifier]?.cancel()
        operationsMap.removeValue(forKey: identifier)
    }
    
    public func cancelAllRequests() {
        queue.cancelAllOperations()
        operationsMap.removeAll()
    }
    
    public func state(of identifier: Identifier<T>) -> State {
        return operationsMap[identifier] != nil ? State.fetching : State.notFetching
    }
}
