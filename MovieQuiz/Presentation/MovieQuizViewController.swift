import UIKit

final class MovieQuizViewController: UIViewController {
    
//MARK: Блок свойств
    // вью модель для вопроса
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // вью модель для состояния "Вопрос показан"
    private struct QuizStepViewModel {
        // картинка с афишей фильма с типом UIImage
        let image: UIImage
        // вопрос о рейтинге квиза
        let question: String
        // строка с порядковым номером этого вопроса (ex. "1/10")
        let questionNumber: String
    }
    
    // вью-модель для состояния "Результат квиза"
    struct QuizResultsViewModel {
        let title: String                   // строка с заголовком алерта
        let text: String                     // строка с текстом о количестве набранных очков
        let buttonText: String   // текст для кнопки алерта
    }
    
    // массив со списком моковых вопросов
    private var questions: [QuizQuestion] = [
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
    
    @IBOutlet private weak var yesButtonStatus: UIButton!
    @IBOutlet private weak var noButtonStatus: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
// MARK: Блок функций
// MARK: - Lifecycle
override func viewDidLoad() {
   super.viewDidLoad()
//        textLabel.font = UIFont(name: "YS Display-Bold", size: 23)
   textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
   imageView.layer.cornerRadius = 20
    questions = questions.shuffled()
    // MARK: отличие от описания, вызов универсальной функции вывода вопроса на экран,
    // вместо вызова этих функций отдельно для первого экрана
    nextScreen()
}

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
   DispatchQueue.main.asyncAfter(deadline:  .now() + 1.0) {
       self.imageView.layer.borderColor = UIColor.clear.cgColor
       self.showNextQuestionResults()
   }
}

private func showNextQuestionResults() {
   if currentQuestionIndex == questions.count - 1 {
       // идем в состояние "Результат квиза"
       let quizResultsViewModel = QuizResultsViewModel(
           title: "Раунд окончен",
           text: "Ваш результат \(correctAnswers)/\(questions.count)",
           buttonText: "Сыграть еще раз!")
       show(quiz: quizResultsViewModel)
   } else {
       currentQuestionIndex += 1
           // идем в стостояние "Вопрос показан"
       nextScreen()
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
// универсальная функция вывода текущего вопроса по его индексу, с конвертацией по модели и ее показом на экране
private func nextScreen() {
   let currentQuestion = questions[currentQuestionIndex]
   let currentQuizStepViewModel = convert(model: currentQuestion)
   show(quiz: currentQuizStepViewModel)
}

// метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
private func convert(model: QuizQuestion) -> QuizStepViewModel {
   let resModel: QuizStepViewModel = QuizStepViewModel(
       image: UIImage(named: model.image) ??  UIImage(),
       question: model.text,
       questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
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
private func show(quiz result: QuizResultsViewModel) {
   let alert = UIAlertController(
       title: result.title,                 // заголовок всплывающего окна
       message: result.text,               // текст во всплывающем окне
       preferredStyle: .alert)     // preferredStyle может быть .alert или .actionSheet
   let action = UIAlertAction(title: result.buttonText, style: .default) { [self] _ in
       // сбрасываем переменную счетчика вопросов
       currentQuestionIndex = 0
       // сбрасываем переменную с количеством правильных ответов
       correctAnswers = 0
       // заново показываем вопрос вызовом функции nextScreen(); вопрос первый, поскольку currentQuestionIndex сброшен в 0
       nextScreen()
       // разблокируем кнопки
       buttonStatus(isEnabled: true)
   }
       alert.addAction(action)
       self.present(alert, animated:  true, completion:  nil)
       questions = questions.shuffled()
}
    
//MARK: блок с аннотацией @IBAction
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let userAnswer = true
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: userAnswer == correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let userAnswer = false
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
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
