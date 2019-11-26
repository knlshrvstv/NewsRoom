//
//  UserDefaults+Util.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/24/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

public extension UserDefaults {
    struct Key<Value> {
        var name: String
        
        public init(name: String) {
            self.name = name
        }
    }
    
    subscript<T>(key: Key<T>) -> T? {
        get {
            return value(forKey: key.name) as? T
        }
        
        set {
            set(newValue, forKey: key.name)
        }
    }
    
    subscript<T>(
        key: Key<T>,
        default defaultProvider: @autoclosure () -> T) -> T {
        get {
            return value(forKey: key.name) as? T
                ?? defaultProvider()
        }
        set {
            setValue(newValue, forKey: key.name)
        }
    }
}
