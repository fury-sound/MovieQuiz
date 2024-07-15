//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.06.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    ///loading success message
    func didLoadDataFromServer()
    ///loading failure message
    func didFailToLoadData(with error: Error)
}
