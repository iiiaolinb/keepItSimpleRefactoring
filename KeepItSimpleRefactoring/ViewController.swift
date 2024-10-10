//
//  ViewController.swift
//  KeepItSimpleRefactoring
//
//  Created by Hudyaev.E on 30/8/2024.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
//        let assistent = RefactoringAssistent.shared
//        assistent.searchSwiftFilesInProject()
//        
//        let swapper = NameSwapper()
//        swapper.searchFuncNamesInProject()
//        swapper.renameFuncInProject()
        
        let appender = CodeAppender()
    }
}

