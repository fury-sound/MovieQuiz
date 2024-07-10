//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 23.06.2024.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject {    
    func show(quiz result: QuizResultsViewModel)
}
