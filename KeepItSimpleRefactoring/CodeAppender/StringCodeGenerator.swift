//
//  StringCodeGenerator.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 12/9/2024.
//

import Foundation

final class StringCodeGenerator {
    
}

enum CodeType: String, CaseIterable {
    case ForEach
    case IfElse
    case String
    
    func getRandomString() -> String {
        switch self {
        case .ForEach: generateForEachString()
        case .IfElse: generateIfElseString()
        case .String: generateStringString()
        }
    }
    
    private func generateForEachString() -> String {
        [0,1,2].forEach { $0 * 2 }
        return ""
    }
    
    private func generateIfElseString() -> String {
        if 1>2 {let x = 1} else {let y = 2}
        return ""
    }
    
    private func generateStringString() -> String {
        
        return ""
    }
}
