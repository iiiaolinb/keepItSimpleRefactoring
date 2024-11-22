//
//  CodeAppender.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 4/9/2024.
//

import Foundation

final class CodeAppender {
    let assistent = RefactoringAssistent.shared
    let generator = WordsGenerator()
    
    func appendNewContentToAllSwiftFiles() {
        //assistent.searchSwiftFilesInProject()
        assistent.swiftFiles.forEach {
            appendNewContent(to: $0.key)
            appendNewFunc(to: $0.key)
        }
    }
    
    private func appendNewContent(to fileName: String?) {
        let filePath = assistent.getFilePathByName(fileName)
        let oldContent = assistent.getContentAtPath(filePath)
        
        let content = getNewContent(from: oldContent)
        
        if let data = content?.data(using: .utf8), let filePath = filePath {
            do {
                let url = URL(fileURLWithPath: filePath)
                try data.write(to: url)
                print("Successfully added random text into the funcctions of file \(fileName ?? "")")
            } catch {
                print("Error: writing to file \(fileName ?? ""): \(error.localizedDescription)")
            }
        } else {
            print("Error: failed to convert data or invalid file path \(fileName ?? "")")
        }
    }
    
    private func getNewContent(from content: String?) -> String? {
        guard let content = content else {
            print("Error: invalid content")
            return nil
        }

        let ranges = content.ranges(of: /func[ ].*[(].*[{]/)
        guard ranges.count > 0, var endIndex = ranges.first?.upperBound else {
            print("Error: func not found or not enough")
            return nil
        }
        
        var startIndex = content.startIndex
        let fisrtPart = content[startIndex..<endIndex]
        let secondPart = content[endIndex..<content.endIndex]
        var result = fisrtPart + secondPart
        var additionalCharsCount = 0
        if ranges.count == 1 {
            result = fisrtPart + "\n" + generateRandomText() + secondPart
        } else {
            for i in 0..<ranges.count {
                endIndex = result.index(ranges[i].upperBound, offsetBy: additionalCharsCount)
                
                let fisrtPart = result[startIndex..<endIndex]
                let secondPart = result[endIndex..<result.endIndex]
                let randomText = generateRandomText()
                result = fisrtPart + "\n" + randomText + secondPart
                additionalCharsCount += randomText.count + 1
            }
        }
        return String(result)
    }
    
    private func generateRandomText() -> String {
        let entityName = generator.generateEntityName()
        let funcString = generateFirstFuncString()
        let firstString = generateFirstRandomString(for: entityName)
        let anotherString = generateAnotherRandomString(for: entityName)

        return CodeUnits.tab.rawValue + funcString + firstString + anotherString + CodeUnits.tab.rawValue + CodeUnits.tab.rawValue + CodeUnits.curleBracketClose.rawValue + CodeUnits.enter.rawValue
    }
    
    private func generateFirstRandomString(for entity: String) -> String {
        var result = ""
        if let UIElement = UIElement.allCases.randomElement()?.rawValue {
            result = CodeUnits.tab.rawValue + CodeUnits.tab.rawValue + CodeUnits.tab.rawValue + CodeUnits.varString.rawValue + CodeUnits.space.rawValue + entity + CodeUnits.space.rawValue + CodeUnits.equal.rawValue + CodeUnits.space.rawValue + UIElement + CodeUnits.figureBracketOpen.rawValue + CodeUnits.figureBracketClose.rawValue + CodeUnits.enter.rawValue
        }
        return result
    }
    
    private func generateAnotherRandomString(for entity: String) -> String {
        var result = ""
        if let property = UIElementProperty.allCases.randomElement() {
            let first = CodeUnits.tab.rawValue + CodeUnits.tab.rawValue + CodeUnits.tab.rawValue + entity + CodeUnits.dot.rawValue + property.rawValue
            let second = CodeUnits.space.rawValue + CodeUnits.equal.rawValue + CodeUnits.space.rawValue
            let third = property.getPropertyType().getPropertyTypeRandomString() + CodeUnits.enter.rawValue
            result = first + second + third
        }
        return result
    }
    
    private func appendNewFunc(to fileName: String?) {
        let filePath = assistent.getFilePathByName(fileName)
        let content = assistent.getContentAtPath(filePath)
        
        guard var content = content else {
            print("Error: invalid content")
            return
        }
        
        let index = content.lastIndex(of: "}")
        guard let index = index else {
            print("Error: invalid index in content")
            return
        }
        
        content.insert(contentsOf: generateRandomFunc(), at: index)//insert(generateRandomFunc(), at: index)
        
        if let data = content.data(using: .utf8), let filePath = filePath {
            do {
                let url = URL(fileURLWithPath: filePath)
                try data.write(to: url)
                print("Successfully added random function to the file \(fileName ?? "")")
            } catch {
                print("Error: writing to file \(fileName ?? ""): \(error.localizedDescription)")
            }
        } else {
            print("Error: failed to convert data or invalid file path \(fileName ?? "")")
        }
    }
    
    private func generateRandomFunc(_ isPrivate: Bool = false) -> String {
        let funcString = generateFirstFuncString(isPrivate)
        let randomText = generateRandomText()
        return funcString + randomText + CodeUnits.tab.rawValue + CodeUnits.curleBracketClose.rawValue + CodeUnits.enter.rawValue
    }
    
    private func generateFirstFuncString(_ isPrivate: Bool = false) -> String {
        let privateString = isPrivate ? CodeUnits.privateString.rawValue + CodeUnits.space.rawValue : ""
        let funcString = CodeUnits.tab.rawValue + privateString + CodeUnits.funcString.rawValue + CodeUnits.space.rawValue + generator.generateFuncName() + CodeUnits.figureBracketOpen.rawValue + CodeUnits.figureBracketClose.rawValue + CodeUnits.space.rawValue + CodeUnits.curleBracketOpen.rawValue + CodeUnits.enter.rawValue
        return funcString
    }
}
