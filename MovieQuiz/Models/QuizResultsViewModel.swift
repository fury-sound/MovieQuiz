//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 18.06.2024.
//

import Foundation

/// вью-модель для состояния "Результат квиза"
struct QuizResultsViewModel {
    /// строка с заголовком алерта
    let title: String
    /// строка с текстом о количестве набранных очков
    let text: String
    /// текст для кнопки алерта
    let buttonText: String
}
