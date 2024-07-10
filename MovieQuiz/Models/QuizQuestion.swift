//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 18.06.2024.
//

import Foundation

/// вью модель для вопроса
struct QuizQuestion {
    /// постер фильма
    let image: String
    /// вопрос о рейтинге фильма
    let text: String
    /// правильный ответ
    let correctAnswer: Bool
}
