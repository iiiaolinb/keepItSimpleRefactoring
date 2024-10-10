//
//  UIElementCodeGenerator.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 12/9/2024.
//

import Foundation
import UIKit

enum UIElement: String, CaseIterable {
    case UIView = "UIView"
    case UILabel = "UILabel"
    case UITextField = "UITextField"
    case UITextView = "UITextView"
    case UIImageView = "UIImageView"
    case UISwitch = "UISwitch"
    case UITableView = "UITableView"
    case UICollectionView = "UICollectionView"
    case UIScrollView = "UIScrollView"
    case UIStackView = "UIStackView"
}

enum UIElementPropertyType: String {
    case CGRectType
    case IntType
    case BoolType
    case CGFloatType
    case UIColorType
    
    func getPropertyTypeRandomString() -> String {
        switch self {
        case .CGRectType: generateCGRectRandomString()
        case .IntType: generateIntRandomString()
        case .BoolType: generateBoolRandomString()
        case .CGFloatType: generateAlphaRandomString()
        case .UIColorType: generateUIColorRandomString()
        }
    }
    
    private func generateCGRectRandomString() -> String {
        return "CGRect(x: \(generateIntRandomString()), y: \(generateIntRandomString()), width: \(generateIntRandomString()), height: \(generateIntRandomString()))"
    }
    
    private func generateIntRandomString() -> String {
        return "\(Int.random(in: 0...100))"
    }
    
    private func generateBoolRandomString() -> String {
        return "\(Bool.random())"
    }
    
    private func generateUIColorRandomString() -> String {
        return "UIColor(red: \(generateCGFloatRandomValue()), green: \(generateCGFloatRandomValue()), blue: \(generateCGFloatRandomValue()), alpha: \(generateAlphaRandomString()))"
    }
    
    private func generateCGFloatRandomValue(inRange from: CGFloat = 0.0, _ to: CGFloat = 255.0) -> CGFloat {
        return CGFloat.random(in: from...to)
    }
    
    private func generateCGFloatRandomString() -> String {
        return "\(generateCGFloatRandomValue())"
    }
    
    private func generateAlphaRandomString() -> String {
        return "\(generateCGFloatRandomValue(inRange: 0.0, 1.0))"
    }
}

enum UIElementProperty: String, CaseIterable {
    case backgroundColor = "backgroundColor"
    case alpha = "alpha"
    case isOpaque = "isOpaque"
    case isHidden = "isHidden"
    
    func getPropertyType() -> UIElementPropertyType {
        switch self {
        case .backgroundColor: .UIColorType
        case .alpha: .CGFloatType
        case .isOpaque, .isHidden: .BoolType
        }
    }
}
