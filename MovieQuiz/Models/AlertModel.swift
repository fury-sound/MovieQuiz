//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.06.2024.
//

import Foundation
import UIKit

struct AlertModel {
    var title: String                 // заголовок всплывающего окна
    var message: String
    var buttonText: String
    var preferredStyle: UIAlertController.Style
    var completion: () -> ()
    var resetStatistics: () -> ()  //additional closure to reset statistics in UserDefaults
    
    init(title: String, message: String, buttonText: String, preferredStyle: UIAlertController.Style, completion: @escaping () -> Void, resetStatistics: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.preferredStyle = preferredStyle
        self.completion = completion
        self.resetStatistics = resetStatistics
    }
}
