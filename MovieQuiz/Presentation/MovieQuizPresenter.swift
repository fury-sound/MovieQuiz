//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.07.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    ///фабрика вопросов. Контроллер будет обращаться за вопросами к ней.
    var questionFactory: QuestionFactoryProtocol?  /// для DI методом или через init()
    let questionAmount: Int = 10 ///общее количество вопросов для 1 квиза
    /// переменная с индексом текущего вопроса, начальное значение 0; (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion? ///вопрос, который видит пользователь.
    /// переменная со счётчиком правильных ответов для 1 квиза, начальное значение закономерно 0
    var correctAnswers = 0
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
    
    // MARK: - QuestionFactoryDelegate (public functions)
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        /// проверка, что вопрос question не nil
        guard let question = question else {
            return
        }
        currentQuestion = question
        let currentQuizStepViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: currentQuizStepViewModel)
        }
    }
    
    func showNextQuestionResults() {
        if self.isLastQuestion() {
            /// calling store function from StatisticsService instance (gameStatistics) to store all data in the UserDefaults
            guard let gameStatistics = viewController?.gameStatistics else { return }
            gameStatistics.store(correct: correctAnswers, total: questionAmount)
            
            /// идем в состояние "Результат квиза"
            let quizResultsViewModel = QuizResultsViewModel(
                title: "Раунд окончен",
                text: "Ваш результат \(correctAnswers)/\(questionAmount)\n" +
                "Количество сыгранных квизов: \(gameStatistics.gamesCount)\n" +
                "Рекорд: \(gameStatistics.bestGame.correct)/\(gameStatistics.bestGame.total) (\(gameStatistics.bestGame.date.dateTimeString))\n" +
                "Средняя точность: \(String(format: "%.2f", (gameStatistics.totalAccuracy)))%",
                buttonText: "Сыграть еще раз!")
            viewController?.show(quiz: quizResultsViewModel)
        } else {
            switchToNextQuestion() //currentQuestionIndex += 1
            /// идем в стостояние "Вопрос показан"
            questionFactory?.loadData()
            viewController?.buttonStatus(isEnabled: true)
        }
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
