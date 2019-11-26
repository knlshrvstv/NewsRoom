//
//  String+Util.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/24/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

public extension String {
    subscript(i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func isCapitalized() -> Bool {
        if let punctuationRegex = try? NSRegularExpression(pattern: #"^[^a-zA-Z0-9]*"#) {
            if let matches = punctuationRegex.firstMatch(in: self, range: NSMakeRange(0, count)) {                
                return self[matches.range.length]?.isUppercase ?? false
            }
        }
        return true
    }
    
    func leadingPunctuations() -> String? {
        // Regex to detect trailing punctuation
        if let punctuationRegex = try? NSRegularExpression(pattern: #"^[^a-zA-Z0-9]*"#) {
            if let matches = punctuationRegex.firstMatch(in: self, range: NSMakeRange(0, count)) {
                let groups = matches.groups(testedString: self)
                
                return groups.first
            }
        }
        
        return nil
    }
    
    func trailingPunctuations() -> String? {
        // Regex to detect trailing punctuation
        if let punctuationRegex = try? NSRegularExpression(pattern: #"[^a-zA-Z0-9]*$"#) {
            if let matches = punctuationRegex.firstMatch(in: self, range: NSMakeRange(0, count)) {
                let groups = matches.groups(testedString: self)
                
                return groups.first
            }
        }
        
        return nil
    }
}
