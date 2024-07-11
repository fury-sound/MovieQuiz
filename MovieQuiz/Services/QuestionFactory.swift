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
    private var movie: MostPopularMovie?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        print("in load data")
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { 
                print("loadData - main.async")
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
//                    print("load success")
                    ///сохраняем фильм в новую переменную
                    self.movies = mostPopularMovies.items ?? []
                    ///сообщаем, что данные загрузились
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
//                    print("load failed")
                    ///сообщаем об ошибке нашему MovieQuizViewController
                    self.delegate?.didFailToLoadData(with: error)
                }
//                print("res", result)
            }
        }
        print("load data end")
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
        print("QuestionFactory - requestNextQuestion")
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            print("Фильмы: \(self.movies.count)")
            let index = (0..<self.movies.count).randomElement() ?? 0
            print(index)
            print(self.movies[index], type(of: self.movies[index]))
//            let movie = self.movies[index]
//            if  movie != nil {
//                print("ok")
//            } else {
//                print("error with movie in requestnNextSession")
//            }
//            guard var movie = self.movies[safe: index] else { 
            guard var movie = self.movies[safe: index] else {
                print(movie)
                print("error with movie in requestnNextSession")
                return
            }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше 7?"
            let correctAnswer = rating > 7
            print(rating, text, correctAnswer)
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
        print("QuestionFactory - requestNextQuestion end")

    }
}
