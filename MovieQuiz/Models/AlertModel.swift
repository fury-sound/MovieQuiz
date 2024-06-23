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
    var completion: (() -> Void)
}
