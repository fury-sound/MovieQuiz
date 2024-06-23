//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 18.06.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
//class QuestionFactory {
    // массив со списком моковых вопросов
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)
    ]
    
//    init(delegate: QuestionFactoryDelegate?) {
//        self.delegate = delegate
//    }
    
    func setQuestionFactoryDelegate(_ delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion()  {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
//        print(index, type(of: index))
//        let question = questions[safe: index]
        let question = questions[ index]
//        print(question, type(of: question))
        delegate?.didReceiveNextQuestion(question: question)
    }
    
}
