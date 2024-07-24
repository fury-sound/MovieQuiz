import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate {
    
    //MARK: Блок свойств
    private var alertModel:  AlertModel?
    private var presenter: MovieQuizPresenter!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButtonStatus: UIButton!
    @IBOutlet private weak var noButtonStatus: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK: Блок функций
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    // MARK: - AlertPresenterDelegate (public functions)
    
    /// метод для показа результатов раунда квиза
    /// принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: QuizResultsViewModel) {
        /// оставил alertModel, которая формируется здесь вместе с замыканиями для запуска новой игры и сброса статистики - отличие от авторского кода
        alertModel =  AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            preferredStyle: .alert,
            completion:  { [weak self] in
                guard let self = self else {return}
                self.presenter.restartGame() //resetQuestionIndex()  //self.currentQuestionIndex = 0
                //                self.presenter.correctAnswers = 0
                self.buttonStatus(isEnabled: true)
            },
            /// additional Reset Statistics closure
            resetStatistics: {[weak self] in
                guard let self = self else {return}
                presenter.resetStatistics()
            })
        guard let alertModel = self.alertModel else {return}
        let alertPresenter = AlertPresenter(alertModel: alertModel)
        alertPresenter.setAlertPresenterDelegate(self)
        alertPresenter.showAlert()
    }
    
    
    // MARK: - public functions
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        /// даём разрешение на рисование рамки
        imageView.layer.masksToBounds = true
        /// толщина рамки
        imageView.layer.borderWidth = 8
        /// радиус скругления углов рамки
        imageView.layer.cornerRadius = 20
        /// блокируем кнопки и меняем цвет их фона на время показа результата
        buttonStatus(isEnabled: false)
        /// красим рамку
        if isCorrectAnswer {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    func makeTransparentImageBorder() {
        self.imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    /// метод блокировки/разблокировки кнопок Да/Нет по результату аргумента (true/false)
    /// Значение false - блокировка на время показа результата ответа на вопрос (рамка)
    /// Значение true - разблокировка после перехода на новый экран
    /// Цвет фона кнопок, пока они заблокированы, меняется на ypGray
    func buttonStatus(isEnabled: Bool) {
        yesButtonStatus.isEnabled = isEnabled
        noButtonStatus.isEnabled = isEnabled
        if isEnabled {
            yesButtonStatus.backgroundColor = .ypWhite
            noButtonStatus.backgroundColor = .ypWhite
        } else {
            yesButtonStatus.backgroundColor = .ypGray
            noButtonStatus.backgroundColor = .ypGray
        }
    }
    
    /// метод вывода модели очередного экрана квиза, принимает QuizStepViewModel
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber // + "/\(questions.count)"
        textLabel.text = step.question
    }
    
    func showLoadingIndicator() {
        /// индикатор загрузки не скрыт
        self.activityIndicator.isHidden = false
        buttonStatus(isEnabled: false)
        /// включаем анимацию
        self.activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        /// индикатор загрузки скрыт
        activityIndicator.isHidden = true
        buttonStatus(isEnabled: true)
    }
    
    /// showing alert for network error case
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз", preferredStyle: .alert,
                               completion: {
            [weak self] in
            guard let self = self else {return}
            self.presenter.restartGame() // а надо ли сбрасывать данные квиза при ошибке сети?
        },
                               resetStatistics: {})
        
        let action = UIAlertAction(title: model.buttonText, style: .default) {  _ in
            model.completion()
        }
        
        let alert = UIAlertController(
            /// заголовок всплывающего окна
            title: model.title,
            /// текст во всплывающем окне
            message:  model.message,
            /// preferredStyle может быть .alert или .actionSheet
            preferredStyle: model.preferredStyle)
        alert.addAction(action)
        self.present(alert, animated:  true, completion:  nil)
    }
    
    //MARK: блок с аннотацией @IBAction
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
