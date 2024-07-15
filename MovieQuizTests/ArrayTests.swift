//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Valery Zvonarev on 15.07.2024.
//
import Foundation
/// не забывайте импортировать фреймворк для тестирования
import XCTest
/// импортируем наше приложение для тестирования
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    /// тест на успешное взятие элемента по индексу
    func testGetValueInRange() {
        // Given
        let array  = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    /// тест на взятие элемента по неправильному индексу
    func testGetValueOutOfRange() {
        // Given
        let array  = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
    
}
