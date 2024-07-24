//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.07.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    ///фабрика вопросов. Контроллер будет обращаться за вопросами к ней.
    private var questionFactory: QuestionFactoryProtocol?  /// для DI методом или через init()
    private let questionAmount: Int = 10 ///общее количество вопросов для 1 квиза
    /// переменная с индексом текущего вопроса, начальное значение 0; (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    private var currentQuestion: QuizQuestion? ///вопрос, который видит пользователь.
    /// переменная со счётчиком правильных ответов для 1 квиза, начальное значение закономерно 0
    private var correctAnswers = 0
    private weak var viewController: MovieQuizViewController?
    private var gameStatistics: StatisticServiceProtocol!
    
    //    init(viewController: MovieQuizViewController) {
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController as? MovieQuizViewController
        gameStatistics = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate (public functions)
    
    func didLoadDataFromServer() {
        ///hiding activity indicator
        viewController?.hideLoadingIndicator()
        viewController?.buttonStatus(isEnabled: true)
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
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
    
    // MARK: - Public functions
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    /// метод создания итогового сообщения для алерта
    func makeResultsMessage() -> String {
        /// calling store function from StatisticsService instance (gameStatistics) to store all data in the UserDefaults
        gameStatistics.store(correct: correctAnswers, total: questionAmount)
        let bestGame = gameStatistics.bestGame
        let totalPlaysCountline = "Количество сыгранных квизов: \(gameStatistics.gamesCount)"
        let currentGameResultLine = "Ваш результат \(correctAnswers)/\(questionAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", (gameStatistics.totalAccuracy)))%"
        let resultMessage = [currentGameResultLine, totalPlaysCountline, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
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
    
    /// additional function to delete statistics data in UserDefaults
    func resetStatistics() {
        let allValues = UserDefaults.standard.dictionaryRepresentation()
        /// deleting UserDefaults - comment to store data
        allValues.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    ///при корректном ответе функция повышает счетчик правильных ответов
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func didAnswer(isYes: Bool) {
        let userAnswer = isYes
        guard let correctAnswer = currentQuestion?.correctAnswer else {
            return
        }
        proceedWithAnswer(isCorrect: userAnswer == correctAnswer)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Private functions
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            /// forming result message after 10 questions
            let resultMessage = makeResultsMessage()
            /// идем в состояние "Результат квиза"
            let quizResultsViewModel = QuizResultsViewModel(
                title: "Раунд окончен",
                text: resultMessage,
                buttonText: "Сыграть еще раз!")
            viewController?.show(quiz: quizResultsViewModel)
        } else {
            switchToNextQuestion() //currentQuestionIndex += 1
            /// идем в стостояние "Вопрос показан"
            questionFactory?.loadData()
            viewController?.buttonStatus(isEnabled: true)
        }
    }
    
    /// приватный метод, который меняет цвет рамки
    /// принимает на вход булевое значение и ничего не возвращает
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer:  isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline:  .now() + 1.0) { [weak self] in
            guard let self = self else {  return }
            viewController?.makeTransparentImageBorder()
            self.proceedToNextQuestionOrResults()
        }
    }
}
