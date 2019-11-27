//
//  Cache.swift
//
//
//  Created by Kunal Shrivastava on 11/26/19.

import Foundation

// TODO: Add on-disc cache so that we can first check the in-memory cache, then on-disc cache and only then make a network request if image is not found in either of those.
// NSCache only supports NSObject and its subclasses as keys. This Cache implementation wrapes over NSCache to smotthen this constraint by further wrapping the Key in a private class that subclasses NSObject. This Cache interface hence provides workable interface for non-NSObject type keys as well. Attribution: https://www.swiftbysundell.com/articles/caching-in-swift/
public final class Cache<Key: Hashable, Value> {
    private let wrappedCache = NSCache<WrappedKey, Node>()
    private let queue = DispatchQueue(label: "CacheQueue", attributes: .concurrent)
    
    public init() {
        wrappedCache.countLimit = 10
    }
    
    func insert(value: Value, forkey key: Key) {
        queue.async(flags: .barrier) { [unowned self] in
            let unwrappedKey = WrappedKey(key: key)
            let node = Node(key: key, value: value)
            self.wrappedCache.setObject(node, forKey: unwrappedKey)
        }
    }
    
    func retrieve(valueFor key: Key) -> Value? {
        queue.sync {
            let wrappedKey = WrappedKey(key: key)
            return wrappedCache.object(forKey: wrappedKey)?.value
        }
    }
    
    func remove(valueFor key: Key) {
        queue.async(flags: .barrier) { [unowned self] in
            let wrappedKey = WrappedKey(key: key)
            self.wrappedCache.removeObject(forKey: wrappedKey)
        }
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(key: Key) {
            self.key = key
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let unwrappedKey = object as? WrappedKey else {
                return false
            }
            
            return unwrappedKey.key == key
        }
        
        override var hash: Int {
            return key.hashValue
        }
    }
}

private extension Cache {
    final class Node {
        let key: Key
        let value: Value
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
}

public extension Cache {
    subscript(key: Key) -> Value? {
        get {
            return retrieve(valueFor: key)
        }
        
        set {
            guard let unwrappedKey = newValue else {
                remove(valueFor: key)
                
                return
            }
            
            insert(value: unwrappedKey, forkey: key)
        }
    }
}
