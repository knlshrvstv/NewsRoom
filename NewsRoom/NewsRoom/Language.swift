//
//  Language.swift
//  NewsRoom
//
//  Created by Kunal Shrivastava on 11/23/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

enum Language: String {
    case english
    case martian
}

extension Language {
    func translate(text: String) -> String {
        guard let languageTranslator = translator() else { return text }
        
        return languageTranslator(text)
    }
    
    // TODO: Add tests
    /**
     - note
        The algorithm is as follows:
        - Split the string into words and spaces
        - Loop over each word and space simultaneosly
            - If word is translatable per the rules, replace it with the replacement
            - Add the corresponding space
            - Repeat until all word-space pair is exhausted
     */
    private func translator() -> ((String) -> String)? {
        switch self {
        case .english:
            print("No translator available to convert text to English")
            return nil
        case .martian:
            return { (text) in
                var tchSet = CharacterSet()
                tchSet.formUnion(.whitespacesAndNewlines)
                let words = text.components(separatedBy: tchSet).filter { $0 != "" }
                var chSet = CharacterSet()
                chSet.formUnion(.alphanumerics)
                chSet.formUnion(.punctuationCharacters)
                chSet.formUnion(.symbols)
                var spaces = text.components(separatedBy: chSet).filter { $0 != "" }

                /**
                 * The number of space based delimiters is equal to number of words minus 1.
                 * Eg: The New York Times has 4 words and has 3 delimiters.
                 * zip only works on arrays with equal count and ignores the difference. To accomodate
                 * for the difference of 1 betwen number of words and spaces, we add a padding of 1.
                 */
                if spaces.count < words.count {
                    spaces.append("")
                }
                
                var translation = ""
                for (word, space) in zip(words, spaces) {
                    /**
                     * RegEx to match a word if it has any alphabet in it
                     */
                    // [^a-zA-Z0-9]*$
                    let canTranlate = word.matches(#"^.*([A-Za-z]+).*$"#) && word.count > 3
                    let replacementWord = word.isCapitalized() ? "Boinga" : "boinga"
                    
                    let trailingPunctuation = word.trailingPunctuations() ?? ""
                    
                    translation += (canTranlate ? replacementWord : word)
                    translation += (canTranlate ? trailingPunctuation : "")
                    translation += space
                }
                
                return translation
            }
        }
    }
}
