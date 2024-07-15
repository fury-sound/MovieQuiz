import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
//        get {
//            /// Возвращаем соответствующее значение
//            return nil
//        }
//        set(newValue) {
//            /// Устанавливаем подходящее значение
//        }
//    }
}
