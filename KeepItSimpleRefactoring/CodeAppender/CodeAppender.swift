//
//  CodeAppender.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 4/9/2024.
//

import Foundation

final class CodeAppender {
    init() {
        for i in 1...10 {
            setup()
        }
    }
    
    func setup() {
        if let UIElement = UIElement.allCases.randomElement()?.rawValue,
           let property = UIElementProperty.allCases.randomElement() {
           let value = property.getPropertyType().getPropertyTypeRandomString()
            let test = UIElement + "." + property.rawValue + " = " + value
            print(test)
        }
    }
}
