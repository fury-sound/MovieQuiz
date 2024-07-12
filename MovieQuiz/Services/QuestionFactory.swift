//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 18.06.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { 
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    ///сохраняем фильм в новую переменную
                    self.movies = mostPopularMovies.items ?? []
                    ///сообщаем, что данные загрузились
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    ///сообщаем об ошибке нашему MovieQuizViewController
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    /// массив со списком моковых вопросов
    //    private let questions: [QuizQuestion] = [
    //        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
    //        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
    //        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
    //        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
    //        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
    //        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
    //        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
    //        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
    //        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
    //        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)
    //    ]
    
    func setQuestionFactoryDelegate(_ delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion()  {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            let movValue: MostPopularMovie? = self.movies[index]
            guard let movie = movValue else {  return }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            ///вычисляем случайное значение для сравнения с рейтингом, в диапазоне от 6 до 10, округляя его до 1 знака после запятой
            var quizRating = round(Float.random(in: 6...10) * 10) / 10.0
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше \(quizRating)?"
            ///сравнение случайного рейтинга с рейтингом из imDb
            let correctAnswer = rating > quizRating
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
        
        //MARK: code for mock array questions
        //        guard let index = (0..<questions.count).randomElement() else {
        //            delegate?.didReceiveNextQuestion(question: nil)
        //            return
        //        }
        //        let question = questions[ index]
        //        delegate?.didReceiveNextQuestion(question: question)
        //    }
//        print("QuestionFactory - requestNextQuestion end")
    }
}
