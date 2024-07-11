//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 22.06.2024.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private var alertModel: AlertModel?
    private var alert: UIAlertController?
    weak var delegate: (UIViewController&AlertPresenterDelegate)?
    
    init(alertModel: AlertModel) {
        self.alertModel = alertModel
        alert = UIAlertController(
            /// заголовок всплывающего окна
            title: alertModel.title,
            /// текст во всплывающем окне
            message: alertModel.message,
            /// preferredStyle может быть .alert или .actionSheet
            preferredStyle: alertModel.preferredStyle)
    }
    
    func setAlertPresenterDelegate(_ delegate: UIViewController&AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func showAlert() {
        /// action for alert button to play one more game, calling completion closure
        let action = UIAlertAction(title: alertModel?.buttonText, style: .default) {  _ in  //слабая ссылка на self
            guard let alertModel = self.alertModel else {return}
            alertModel.completion()
        }
        /// action for additional Reset Statistics button: resetting UserDefaults values calling completion closure afterwards
        let actionReset = UIAlertAction(title: "Сбросить статистику", style: .default) {_ in
            guard let alertModel = self.alertModel else {return}
            alertModel.resetStatistics()
            alertModel.completion()
        }
        guard let delegate = delegate, let alert = alert else { return }
        alert.addAction(action)
        alert.addAction(actionReset)
        delegate.present(alert, animated:  true, completion:  nil)
    }
    
    
    
}
