import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    //MARK: Блок свойств
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 8
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    //фабрика вопросов. Контроллер будет обращаться за вопросами к ней.
    //    private var questionFactory: QuestionFactoryProtocol? // для DI свойством
    var questionFactory: QuestionFactoryProtocol = QuestionFactory() // для DI методом или через init()
    private let questionAmount: Int = 10 //общее количество вопросов для квиза
    private var currentQuestion: QuizQuestion? //вопрос, который видит пользователь.
    private var alertModel:  AlertModel?
    
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
        let questionFactory = QuestionFactory()  //Создаём экземпляр фабрики для ее настройки
        //    questionFactory.delegate = self                       // Устанавливаем связь фабрика – делегат через свойство.
        questionFactory.setQuestionFactoryDelegate(self) // связь через метод в QuestionFactory
        self.questionFactory = questionFactory  //Сохраняем подготовленный экземляр в свойство вью-контроллера
        //устраняем дублирование кода в реализации Yandex.
        // В моем коде заменяем вызовы nextScreen() (имел ту же функцию, но в рамках 1 класса)
        questionFactory.requestNextQuestion()
        // MARK: отличие от описания, вызов универсальной функции вывода вопроса на экран,
        // вместо вызова этих функций отдельно для первого экрана
        //    nextScreen() // закомментирован. Функционал ушел в метод didReceiveNextQuestion()
        //        print(Bundle.main.bundlePath)
        //    if let imagePath = Bundle.main.path(forResource: "AppIcon60x60@2x", ofType: "png") {
        //        let image = UIImage(contentsOfFile: imagePath)
        //        if image != nil {print("Image is here")} else {print("No image")}
        //        print(image?.description)
        //    }
        //        print(NSHomeDirectory())
        //        UserDefaults.standard.set(true, forKey: "viewDidLoad")
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос question не nil
        guard let question = question else {
            return
        }
        currentQuestion = question
        let currentQuizStepViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: currentQuizStepViewModel)
        }
        //    next Screen()
    }
    
    // MARK: - Private function
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8               // толщина рамки
        imageView.layer.cornerRadius = 20         // радиус скругления углов рамки
        buttonStatus(isEnabled: false)     // блокируем кнопки и меняем цвет их фона на время показа результата
        // красим рамку
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        // Yandex solution - оставил для сравнения
        //        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline:  .now() + 1.0) { [weak self] in
            guard let self = self else {  return }
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionResults()
        }
    }
    
    private func showNextQuestionResults() {
        if currentQuestionIndex == questionAmount - 1 {
            // идем в состояние "Результат квиза"
            let quizResultsViewModel = QuizResultsViewModel(
                title: "Раунд окончен",
                text: "Ваш результат \(correctAnswers)/\(questionAmount)",
                buttonText: "Сыграть еще раз!")
            show(quiz: quizResultsViewModel)
        } else {
            currentQuestionIndex += 1
            // идем в стостояние "Вопрос показан"
            //       nextScreen()
            questionFactory.requestNextQuestion() //заменяеи nextScreen()
            buttonStatus(isEnabled: true)
        }
    }
    
    // метод блокировки/разблокировки кнопок Да/Нет по результату аргумента (true/false)
    // Значение false - блокировка на время показа результата ответа на вопрос (рамка)
    // Значение true - разблокировка после перехода на новый экран
    // Цвет фона кнопок, пока они заблокированы, меняется на ypGray
    private func buttonStatus(isEnabled: Bool) {
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
    
    // MARK: отличие от реализации в описании
    // универсальная функция вывода текущего вопроса по его индексу, с конвертацией по модели и ее показом на экране. Закомментирован - функционал ушел в didReceiveNextQuestion()
    //private func nextScreen() {
    //   let currentQuestion = questions[currentQuestionIndex] // old code
    //    if let nextQuestion = questionFactory.requestNextQuestion() {
    //        currentQuestion = nextQuestion
    //        let currentQuizStepViewModel = convert(model: nextQuestion)
    //        show(quiz: currentQuizStepViewModel)
    //    }
    //}
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let resModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ??  UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)"
        )
        return resModel
    }
    
    // метод вывода модели очередного экрана квиза, принимает QuizStepViewModel
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber // + "/\(questions.count)"
        textLabel.text = step.question
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: QuizResultsViewModel) {
        //        var calPresenter = {self.present(alertPresenter?.alert, animated:  true, completion:  nil)}
        alertModel =  AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            preferredStyle: .alert,
            completion:  { [weak self] in
                guard let self = self else {return}
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.buttonStatus(isEnabled: true)
                self.questionFactory.requestNextQuestion()
            })
        //        alertModel?.completion()
        guard let alertModel = self.alertModel else {return}
        let alertPresenter = AlertPresenter(alertModel: alertModel)
        alertPresenter.setAlertPresenterDelegate(self)
        alertPresenter.showAlert()
        //        guard let alert = alertPresenter.alert else {return}
        //        self.present(alert, animated:  true, completion:  nil)
        
        //    alertPresenter.alertModel?.completion()
        
        //    let alert = UIAlertController(
        //       title: result.title,                 // заголовок всплывающего окна
        //       message: result.text,               // текст во всплывающем окне
        //       preferredStyle: .alert)     // preferredStyle может быть .alert или .actionSheet
        //
        //    let action = UIAlertAction(title: result.buttonText, style: .default) {  [weak self]  _ in  //слабая ссылка на self
        //       // убрали увеличение счетчика на класс при использовании self в переменных замыкания с помощью [weak self]
        //       // проверяем опциональную слабую ссылку на nil (разворачиваем)
        //       guard let self = self else { return }
        //       // сбрасываем переменную счетчика вопросов
        //       self.currentQuestionIndex = 0
        //       // сбрасываем переменную с количеством правильных ответов
        //       self.correctAnswers = 0
        //       // заново показываем вопрос вызовом функции nextScreen(); вопрос первый, поскольку currentQuestionIndex сброшен в 0
        //      // self.nextScreen()
        //       self.questionFactory.requestNextQuestion() //заменяет nextScreen()
        //       // разблокируем кнопки
        //       self.buttonStatus(isEnabled: true)
        //   }
        //       alert.addAction(action)
        //       self.present(alert, animated:  true, completion:  nil)
    }
    
    //MARK: блок с аннотацией @IBAction
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        //        print("\(self.description) - button pressed")
        let userAnswer = true
        //        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        guard let correctAnswer = currentQuestion?.correctAnswer else {
            //            print("\(self.description) - no correct answer")
            return
        }
        //        print("\(self.description) - Before showAnswerResult")
        showAnswerResult(isCorrect: userAnswer == correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        //        print("\(self.description) - button pressed")
        let userAnswer = false
        //        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        guard let correctAnswer = currentQuestion?.correctAnswer else {
            //            print("\(self.description) - no correct answer")
            return
        }
        //        print("\(self.description) - Before showAnswerResult")
        showAnswerResult(isCorrect: userAnswer == correctAnswer)
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
