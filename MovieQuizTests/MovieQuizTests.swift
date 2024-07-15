//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Valery Zvonarev on 15.07.2024.
//

import XCTest

struct ArithmeticOperationsSyncTests {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func deduct(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiply(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

struct ArithmeticOperationsAsyncTests {
    
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 + num2)
        }
    }
    
    func deduct(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiply(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
}


final class MovieQuizTests: XCTestCase {
    
    func testAddition() throws {
        //Given
        let arithmeticOperations = ArithmeticOperationsSyncTests()
        let num1 = 1
        let num2 = 2
        
        //When
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        //Then
        /// сравниваем результат выполнения функции и наши ожидания
        XCTAssertEqual(result, 3)
    }
    
    func testAdditionAsync() throws {
        //Given
        let arithmeticOperations = ArithmeticOperationsAsyncTests()
        let num1 = 1
        let num2 = 2
        
        //When
        let expectation = expectation(description: "Addition function expectation")
        arithmeticOperations.addition(num1: num1, num2: num2) { result in
            //Then
            XCTAssertEqual(result, 3)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    
    //    override func setUpWithError() throws {
    //        // Put setup code here. This method is called before the invocation of each test method in the class.
    //    }
    //
    //    override func tearDownWithError() throws {
    //        // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    }
    //
    //    func testExample() throws {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //        // Any test you write for XCTest can be annotated as throws and async.
    //        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    //        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    //    }
    //
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
