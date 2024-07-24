//
//  MovieLoaderTests.swift
//  MovieQuizTests
//
//  Created by Valery Zvonarev on 15.07.2024.
//

import XCTest
@testable import MovieQuiz

class MovieLoaderTests: XCTestCase {
    func testSuccessLoading() {
        // Given
        ///не хотим эмулировать ошибку, если false
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
//        let loader = MoviesLoader()

        // When
        /// так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                /// проверим, что пришло, два фильма — в тестовых данных их два
                ///for error stub
                XCTAssertEqual(movies.items?.count, 2)
                ///for real connection
//                XCTAssertEqual(movies.items?.count, 250)
                /// сравниваем данные с тем, что мы предполагали
                expectation.fulfill()
                /// мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
            case .failure(_):
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
        waitForExpectations(timeout: 15)
    }
    
    func testFailureLoading() {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Loading expectation")
        
        // Then
        loader.loadMovies { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected error")
            case .failure(let error):
                XCTAssertNotNil(error)
                print("Can't load data:", error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}

struct StubNetworkClient: NetworkRouting {
    
    /// тестовая ошибка
    enum TestError: Error {
        case test
    }
    
    /// параметр для эмуляции успешного ответа или ошибки сети
    let emulateError: Bool
    
    func fetch(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponse))
        }
    }
    
    private var expectedFailure: Data {
      """
        """.data(using: .utf8) ?? Data()        
    }
    
    private var expectedResponse: Data {
        """
{
           "errorMessage" : "",
           "items" : [
              {
                 "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                 "fullTitle" : "Prey (2022)",
                 "id" : "tt11866324",
                 "imDbRating" : "7.2",
                 "imDbRatingCount" : "93332",
                 "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                 "rank" : "1",
                 "rankUpDown" : "+23",
                 "title" : "Prey",
                 "year" : "2022"
              },
              {
                 "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                 "fullTitle" : "The Gray Man (2022)",
                 "id" : "tt1649418",
                 "imDbRating" : "6.5",
                 "imDbRatingCount" : "132890",
                 "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                 "rank" : "2",
                 "rankUpDown" : "-1",
                 "title" : "The Gray Man",
                 "year" : "2022"
              }
            ]
          }
""".data(using: .utf8) ?? Data()
    }
}

