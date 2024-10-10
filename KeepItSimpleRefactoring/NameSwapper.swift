//
//  NameSwapper.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 31/8/2024.
//

import Foundation


final class NameSwapper {
    let assistent = RefactoringAssistent.shared
    
    func searchFuncNamesInProject() {
        assistent.swiftFiles.keys.forEach { searchFuncNamesInFile($0) }
        print("Successfully found \(assistent.funcNames.count) replacement functions in the project")
    }
    
    private func searchFuncNamesInFile(_ fileName: String?) {
        let filePath = assistent.getFilePathByName(fileName)
        let content = assistent.getContentAtPath(filePath)
        let names = assistent.getAllFuncNamesIn(content)
        print("Successfully found \(names.count) replacement functions in the file \(String(describing: fileName))")
        names.forEach { !assistent.funcNames.contains($0) ? assistent.funcNames.append($0) : nil }
    }
    
    //MARK: - RENAME
    
    func renameFuncInProject() {
        assistent.funcNames.forEach { renameIfContainsFunc($0) }
    }
    
    private func renameIfContainsFunc(_ funcName: String?) {
        guard let funcName = funcName, !funcName.isEmpty else {
            print("Error: func name for rename is empty")
            return
        }
        let generator = WordsGenerator()
        let newName = generator.generateFuncName()
        assistent.swiftFiles.keys.forEach {
            let filePath = assistent.getFilePathByName($0)
            var content = assistent.getContentAtPath(filePath)
            if var content = content, content.contains(funcName) {
                content = content.replacingOccurrences(of: funcName, with: newName)
                if let data = content.data(using: .utf8), let filePath = filePath {
                    do {
                        let url = URL(fileURLWithPath: filePath)
                        try data.write(to: url)
                        print("Successfully changed the names of \(funcName) to \(newName) in the file \($0)")
                    } catch {
                        print("Error: writing to file \(String(describing: $0)): \(error.localizedDescription)")
                    }
                } else {
                    print("Error: failed to convert data or invalid file path")
                }
            }
        }
    }
}
