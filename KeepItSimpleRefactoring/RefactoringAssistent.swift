//
//  RefactoringAssistent.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 4/9/2024.
//

import Foundation

final class RefactoringAssistent {
    
    static let shared = RefactoringAssistent()
    
    private init() {}
    
    var swiftFiles = [String: String]()
    var funcNames = [String]()
    
    //MARK: - SEARCH
    
    func searchSwiftFilesInProject() {
        searchSwiftFilesInFolder()
        print("Successfully found \(swiftFiles.count) swift files")
    }
    
    private func searchSwiftFilesInFolder(_ folder: String = "") {
        let fileManager = FileManager.default
        var path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.path(percentEncoded: false) ?? ""
        path = !folder.isEmpty ? folder : path

        do {
            let items = try fileManager.contentsOfDirectory(atPath: path)
            for item in items {
                var isDir: ObjCBool = false
                if fileManager.fileExists(atPath: path.appending(item), isDirectory: &isDir) {
                    if isDir.boolValue && isValidFolder(folder) {
                        searchSwiftFilesInFolder(path.appending(item + "/"))
                    } else {
                        if item.contains(".swift") {
                            swiftFiles[item] = path.appending(item)
                        }
                    }
                } else {
                    print("Error: wrong path")
                }
            }
        } catch {
            print("Error: failed to get contents from directory \(error.localizedDescription)")
        }
    }
    
    //MARK: - GETTER
    
    func getAllFuncNamesIn(_ content: String?) -> [String] {
        guard let content = content, !content.isEmpty else {
            print("Error: content is empty or invalid")
            return []
        }
        let from = "func "
        let to = "("
        var result = [String]()
        content.components(separatedBy: from).dropFirst().compactMap { sub in
            (sub.range(of: to)?.lowerBound).flatMap { endRange in
                let name = String(sub[sub.startIndex ..< endRange]).replacingOccurrences(of: " ", with: "")
                !result.contains(name) && isPossibleRenameFunc(name) ? result.append(name) : nil
            }
        }
        return result
    }
    
    private func getContentOfFile(inPath filePath: String?) -> String? {
        guard let filePath = filePath else {
            print("Error: file path is empty or invalid")
            return nil
        }
        var content = ""
        do {
            content = try String(contentsOfFile: filePath, encoding: .utf8)
        } catch {
            print("Error: content in file - \(error.localizedDescription)")
        }
        return content
    }
    
    private func isValidFolder(_ folder: String) -> Bool {
        var result = true
        Library.invalidFolderNames.forEach { folder.contains($0) ? result = false : nil }
        return result
    }
    
    private func isPossibleRenameFunc(_ name: String) -> Bool {
        var result = true
        Library.invalidFuncNames.forEach { name == $0 ? result = false : nil }
        return result
    }
    
    func getFilePathByName(_ fileName: String?) -> String? {
        guard let name = fileName, let filePath = swiftFiles[name] else {
            print("Error: file name is empty or invalid")
            return nil
        }
        return filePath
    }
    
    func getContentAtPath(_ filePath: String?) -> String? {
        guard let content = getContentOfFile(inPath: filePath), !content.isEmpty else {
            print("Error: file path is empty or invalid")
            return nil
        }
        return content
    }
}
