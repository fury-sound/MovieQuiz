import UIKit

final class MovieQuizViewController: UIViewController {
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // вью модель для состояния "Вопрос показан"
    struct QuizStepViewModel {
        // картинка с афишей фильма с типом UIImage
        let image: UIImage
        // вопрос о рейтинге квиза
        let question: String
        // строка с порядковым номером этого вопроса (ex. "1/10")
        let questionNumber: String
    }
    
    // массив со списком моковых вопросов
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
    
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let userAnswer = true
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: userAnswer == correctAnswer)
//        currentQuestionIndex += 1
//        nextScreen()
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        let userAnswer = false
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: userAnswer == correctAnswer)
//        currentQuestionIndex += 1
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nextScreen()
//        imageView.backgroundColor = .green
//        imageView.image = UIImage(named:  "LaunchScreen")
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8               // толщина рамки
        imageView.layer.cornerRadius = 6            // радиус скругления углов рамки
        // красим рамку
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        //Yandex solution
//        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    private func nextScreen() {
        let currentQuestion = questions[currentQuestionIndex]
        let currentQuizStepViewModel = convert(model: currentQuestion)
        show(quiz: currentQuizStepViewModel)
//        return currentQuestion.correctAnswer
    }
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        var resModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ??  UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return resModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber // + "/\(questions.count)"
        textLabel.text = step.question
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
