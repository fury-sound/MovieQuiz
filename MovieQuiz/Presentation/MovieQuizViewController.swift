import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    //MARK: Блок свойств
    ///фабрика вопросов. Контроллер будет обращаться за вопросами к ней.
//    var questionFactory: QuestionFactoryProtocol?  // для DI методом или через init()
    /// переменная с индексом текущего вопроса, начальное значение 0
    /// (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    //    private var currentQuestionIndex = 0
    /// переменная со счётчиком правильных ответов для 1 квиза, начальное значение закономерно 0
//    private var correctAnswers = 0
    //    private let questionAmount: Int = 10 ///общее количество вопросов для 1 квиза
//    private var currentQuestion: QuizQuestion? ///вопрос, который видит пользователь.
    private var alertModel:  AlertModel?
//    var gameStatistics: StatisticServiceProtocol?
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
//        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate:  self)  ///Создаём экземпляр фабрики для ее настройки
//        questionFactory.setQuestionFactoryDelegate(self) /// связь через метод в QuestionFactory
//        self.questionFactory = questionFactory  ///Сохраняем подготовленный экземляр в свойство вью-контроллера
//        gameStatistics = StatisticService()
        showLoadingIndicator()
        /// вызов функций для первого экрана
//        self.questionFactory?.loadData() // как вызываем первый экран?
    }
    
    // MARK: - QuestionFactoryDelegate (public functions)
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//    }
    
//    func didLoadDataFromServer() {
//        ///hiding activity indicator
//        activityIndicator.isHidden = true
//        buttonStatus(isEnabled: true)
//        questionFactory?.requestNextQuestion()
//    }
    
//    func didFailToLoadData(with error: any Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
    // MARK: - AlertPresenterDelegate (public functions)
    
    /// метод для показа результатов раунда квиза
    /// принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: QuizResultsViewModel) {
//        let message = presenter.makeResultsMessage()
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
    
    
    // MARK: - Private functions
    
    /// additional function to delete statistics data in UserDefaults
//    private func resetStatistics() {
//        let allValues = UserDefaults.standard.dictionaryRepresentation()
//        /// deleting UserDefaults - comment to store data
//        allValues.keys.forEach { key in
//            UserDefaults.standard.removeObject(forKey: key)
//        }
//    }
    
    /// приватный метод, который меняет цвет рамки
    /// принимает на вход булевое значение и ничего не возвращает
//    func showAnswerResult(isCorrect: Bool) {
//        didAnswer(isCorrectAnswer:  isCorrect)
//        highlightImageBorder(isCorrectAnswer: isCorrect)
// 
//        DispatchQueue.main.asyncAfter(deadline:  .now() + 1.0) { [weak self] in
//            guard let self = self else {  return }
//            self.imageView.layer.borderColor = UIColor.clear.cgColor
//            self.presenter.showNextQuestionResults()
//        }
//    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        /// даём разрешение на рисование рамки
        imageView.layer.masksToBounds = true
        /// толщина рамки
        imageView.layer.borderWidth = 8
        /// радиус скругления углов рамки
        imageView.layer.cornerRadius = 20
        /// блокируем кнопки и меняем цвет их фона на время показа результата
        buttonStatus(isEnabled: false)
//        presenter.didAnswer(isCorrectAnswer: isCorrectAnswer) //при корректном ответе повышаем счетчик правильных ответов - надо ли это делать тут?
        /// красим рамку
        if isCorrectAnswer {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
//            presenter.correctAnswers += 1 //счетчик правильных ответов в презентере - увеличиваем так или через функцию выше
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    func makeTransparentImageBorder() {
        self.imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
//    private func showNextQuestionResults() {
//        //        if currentQuestionIndex == questionAmount - 1 {
//        if presenter.isLastQuestion() {
//            /// calling store function from StatisticsService instance (gameStatistics) to store all data in the UserDefaults
//            guard let gameStatistics else { return }
//            gameStatistics.store(correct: correctAnswers, total: presenter.questionAmount)
//            
//            /// идем в состояние "Результат квиза"
//            let quizResultsViewModel = QuizResultsViewModel(
//                title: "Раунд окончен",
//                text: "Ваш результат \(correctAnswers)/\(presenter.questionAmount)\n" +
//                "Количество сыгранных квизов: \(gameStatistics.gamesCount)\n" +
//                "Рекорд: \(gameStatistics.bestGame.correct)/\(gameStatistics.bestGame.total) (\(gameStatistics.bestGame.date.dateTimeString))\n" +
//                "Средняя точность: \(String(format: "%.2f", (gameStatistics.totalAccuracy)))%",
//                buttonText: "Сыграть еще раз!")
//            show(quiz: quizResultsViewModel)
//        } else {
//            presenter.switchToNextQuestion() //currentQuestionIndex += 1
//            /// идем в стостояние "Вопрос показан"
//            questionFactory?.loadData()
//            buttonStatus(isEnabled: true)
//        }
//    }
    
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
    
    /// метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    //    private func convert(model: QuizQuestion) -> QuizStepViewModel {
    //        let resModel: QuizStepViewModel = QuizStepViewModel(
    //            image: UIImage(data: model.image) ??  UIImage(),
    //            question: model.text,
    //            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)"
    //        )
    //        return resModel
    //    }
    
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
//            self.presenter.correctAnswers = 0
//            self.questionFactory?.loadData()
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
