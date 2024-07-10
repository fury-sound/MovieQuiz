//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.06.2024.
//

import Foundation
import UIKit

struct AlertModel {
    /// заголовок всплывающего окна
    let title: String
    let message: String
    let buttonText: String
    let preferredStyle: UIAlertController.Style
    let completion: () -> ()
    ///additional closure to reset statistics in UserDefaults
    let resetStatistics: () -> ()
}
