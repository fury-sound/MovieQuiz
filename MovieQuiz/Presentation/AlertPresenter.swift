//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.06.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private var alertModel: AlertModel?
    private var alert: UIAlertController?
    weak var delegate: (UIViewController&AlertPresenterDelegate)?
    
    init(alertModel: AlertModel) {
        self.alertModel = alertModel
        alert = UIAlertController(
            title: alertModel.title,                 // заголовок всплывающего окна
            message: alertModel.message,               // текст во всплывающем окне
            preferredStyle: alertModel.preferredStyle)     // preferredStyle может быть .alert или .actionSheet
    }
    
    func setAlertPresenterDelegate(_ delegate: UIViewController&AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func showAlert() {
        let action = UIAlertAction(title: alertModel?.buttonText, style: .default) {  _ in  //слабая ссылка на self
            guard let alertModel = self.alertModel else {return}
            alertModel.completion()
        }
        guard let delegate = delegate, let alert = alert else { return }
        alert.addAction(action)
        delegate.present(alert, animated:  true, completion:  nil)
    }
}
