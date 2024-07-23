//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.07.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    let questionAmount: Int = 10 ///общее количество вопросов для 1 квиза
    /// переменная с индексом текущего вопроса, начальное значение 0; (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion? ///вопрос, который видит пользователь.
    weak var viewController: MovieQuizViewController?
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    /// метод конвертации, который принимает моковый/реальный вопрос и возвращает вью модель для экрана вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let resModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ??  UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)"
        )
        return resModel
    }
    
    private func didAnswer(isYes: Bool) {
        let userAnswer = isYes
        guard let correctAnswer = currentQuestion?.correctAnswer else {
            return
        }
        viewController?.showAnswerResult(isCorrect: userAnswer == correctAnswer)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
}
