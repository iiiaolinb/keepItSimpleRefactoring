//
//  WordsGenerator.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 30/8/2024.
//

import Foundation

fileprivate enum Separator: String {
    case none = ""
    case space = " "
    case dot = "."
    case newLine = "\n"
}

enum GeneratorType {
    case funcName, entityName, sentence
}

final class WordsGenerator {
    private let minWordsCountInSentence = 4
    private let maxWordsCountInSentence = 16
    private let minSentencesCountInParagraph = 3
    private let maxSentencesCountInParagraph = 9
    private let minWordsCountInTitle = 2
    private let maxWordsCountInTitle = 7
    private let shortTweetMaxLength = 140
    private let tweetMaxLength = 280
    
    public func generateFuncName() -> String {
        return words(3, generatorType: .funcName)
    }
    
    public func generateEntityName() -> String {
        return words(3, generatorType: .entityName)
    }

    /// Generates a single word.
    private var word: String {
        return Library.allWords.randomElement()!
    }
    
    /// Generates multiple words whose count is defined by the given value.
    private func words(_ count: Int, generatorType: GeneratorType) -> String {
        return _compose(word, count: count, joinBy: .none, generatorType: generatorType)
    }
    
    /// Generates a single sentence.
    private var sentence: String {
        let numberOfWords = Int.random(
            in: minWordsCountInSentence...maxWordsCountInSentence
        )
        
        return _compose(
            word,
            count: numberOfWords,
            joinBy: .space,
            endWith: .dot,
            decorate: { $0.firstLetterCapitalized }
        )
    }
    
    /// Generates multiple sentences whose count is defined by the given value.
    private func sentences(_ count: Int) -> String {
        return _compose(
            sentence,
            count: count,
            joinBy: .space
        )
    }
    
    /// Generates multiple sentences whose count is selected from within the given range.
    private func sentences(_ range: Range<Int>) -> String {
        return _compose(sentence, count: Int.random(in: range), joinBy: .space)
    }
    
    /// Generates multiple sentences whose count is selected from within the given closed range.
    private func sentences(_ range: ClosedRange<Int>) -> String {
        return _compose(sentence, count: Int.random(in: range), joinBy: .space)
    }
    
    /// Generates a single paragraph.
    private var paragraph: String {
        let numberOfSentences = Int.random(
            in: minSentencesCountInParagraph...maxSentencesCountInParagraph
        )
        
        return _compose(
            sentence,
            count: numberOfSentences,
            joinBy: .space
        )
    }
    
    /// Generates multiple paragraphs whose count is defined by the given value.
    private func paragraphs(_ count: Int) -> String {
        return _compose(
            paragraph,
            count: count,
            joinBy: .newLine
        )
    }
    
    /// Generates multiple paragraphs whose count is selected from within the given range.
    private func paragraphs(_ range: Range<Int>) -> String {
        return _compose(
            paragraph,
            count: Int.random(in: range),
            joinBy: .newLine
        )
    }
    
    /// Generates multiple paragraphs whose count is selected from within the given closed range.
    private func paragraphs(_ range: ClosedRange<Int>) -> String {
        return _compose(
            paragraph,
            count: Int.random(in: range),
            joinBy: .newLine
        )
    }
    
    /// Generates a capitalized title.
    private var title: String {
        let numberOfWords = Int.random(
            in: minWordsCountInTitle...maxWordsCountInTitle
        )
        
        return _compose(
            word,
            count: numberOfWords,
            joinBy: .space,
            decorate: { $0.capitalized }
        )
    }
    
    /// Generates a first name.
    private var firstName: String {
        return Library.firstNames.randomElement()!
    }
    
    /// Generates a last name.
    private var lastName: String {
        return Library.lastNames.randomElement()!
    }
    
    /// Generates a full name.
    private var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    /// Generates an email address.
    private var emailAddress: String {
        let emailDelimiter = Library.emailDelimiters.randomElement()!
        let emailDomain = Library.emailDomains.randomElement()!
        
        return "\(firstName)\(emailDelimiter)\(lastName)@\(emailDomain)".lowercased()
    }
    
    /// Generates a URL.
    private var url: String {
        let urlScheme = Library.urlSchemes.randomElement()!
        let urlDomain = Library.urlDomains.randomElement()!
        return "\(urlScheme)://\(urlDomain)"
    }

    /// Generates a random tweet which is shorter than 140 characters.
    private var shortTweet: String {
        return _composeTweet(shortTweetMaxLength)
    }
    
    /// Generates a random tweet which is shorter than 280 characters.
    private var tweet: String {
        return _composeTweet(tweetMaxLength)
    }
    
    private func _compose(
        _ provider: @autoclosure () -> String,
        count: Int,
        joinBy middleSeparator: Separator,
        endWith endSeparator: Separator = .none,
        generatorType: GeneratorType = .sentence,
        decorate decorator: ((String) -> String)? = nil
    ) -> String {
        var string = ""
        
        for index in 0..<count {
            if (generatorType == .funcName && string.isEmpty) || generatorType == .sentence {
                string += provider()
            } else {
                string += provider().capitalized
            }
            
            if (index < count - 1) {
                string += middleSeparator.rawValue
            } else {
                string += endSeparator.rawValue
            }
        }
        
        if let decorator = decorator {
            string = decorator(string)
        }
        
        return string
    }
    
    private func _composeTweet(_ maxLength: Int) -> String {
        for numberOfSentences in [4, 3, 2, 1] {
            let tweet = sentences(numberOfSentences)
            if tweet.count < maxLength {
                return tweet
            }
        }
        
        return ""
    }
}
