//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 18.06.2024.
//

import UIKit

// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
    let image: UIImage                                  // картинка с афишей фильма с типом UIImage
    let question: String                            // вопрос о рейтинге квиза
    let questionNumber: String           // строка с порядковым номером этого вопроса (ex. "1/10")
}
