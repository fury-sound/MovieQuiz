//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.06.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    var alertModel: AlertModel?
    var alert: UIAlertController?
    weak var delegate: MovieQuizViewController?
    
    init(alertModel: AlertModel) {
        self.alertModel = alertModel
//        setAlertModel(alertModelData: self.alertModel?)
        alert = UIAlertController(
           title: alertModel.title,                 // заголовок всплывающего окна
           message: alertModel.message,               // текст во всплывающем окне
            preferredStyle: alertModel.preferredStyle)     // preferredStyle может быть .alert или .actionSheet
    }
    
    func setQuestionFactoryDelegate(_ delegate: MovieQuizViewController) {
        self.delegate = delegate
    }
    
//    func setAlertModel(alertModelData: AlertModel) {
//        alert = UIAlertController(
//            title: alertModelData.title,                 // заголовок всплывающего окна
//            message: alertModelData.message,               // текст во всплывающем окне
//            preferredStyle: alertModelData.preferredStyle)     // preferredStyle может быть .alert или .actionSheet
////            completion()
//        print(alert?.description)
//    }
    

    func showAlert() {
            let action = UIAlertAction(title: alertModel?.buttonText, style: .default) {  [weak delegate]  _ in  //слабая ссылка на self
                // убрали увеличение счетчика на класс при использовании self в переменных замыкания с помощью [weak self]
                // проверяем опциональную слабую ссылку на nil (разворачиваем)
                guard let delegate = delegate else { return }
                // сбрасываем переменную счетчика вопросов
                delegate.currentQuestionIndex = 0
                // сбрасываем переменную с количеством правильных ответов
                delegate.correctAnswers = 0
                // заново показываем вопрос вызовом функции nextScreen(); вопрос первый, поскольку currentQuestionIndex сброшен в 0
                // self.nextScreen()
                delegate.questionFactory.requestNextQuestion() //заменяет nextScreen()
                // разблокируем кнопки
                delegate.buttonStatus(isEnabled: true)
            }
        guard let delegate = delegate, let alert = alert else { return }
            alert.addAction(action)
//            print(alert.description)
            delegate.present(alert, animated:  true, completion:  nil)
    }
}
