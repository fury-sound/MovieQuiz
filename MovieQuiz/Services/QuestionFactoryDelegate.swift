//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.06.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() ///loading success message
    func didFailToLoadData(with error: Error) ///loading failure message
}
