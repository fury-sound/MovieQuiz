//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 26.06.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
   
    private let storage: UserDefaults = .standard
    private var correctAnswers: Int = 0
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: "gamesCount")
        }
        set {
            storage.set(newValue, forKey: "gamesCount")
        }
    }
    
    var bestGame: GameResult {
        get {
            let gameResultCorrect = storage.integer(forKey: "gameResultCorrect")
            let gameResultTotal = storage.integer(forKey: "gameResultTotal")
            let gameResultDate = storage.object(forKey: "gameResultDate") as? Date ??  Date()
            let gameResult = GameResult(correct: gameResultCorrect, total: gameResultTotal, date: gameResultDate)
            return gameResult
        }
        set {
            storage.set(newValue, forKey: "gameResultCorrect")
            storage.set(newValue, forKey: "gameResultTotal")
            storage.set(newValue, forKey: "gameResultDate")
        }
    }
        
    var totalAccuracy: Double {
        get {
            gamesCount > 0 ? Double(correctAnswers / storage.integer(forKey: "gameResultDate") * 100) : 0
        }
        set {
            storage.set(newValue, forKey: "totalAccuracy")
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        <#code#>
    }
    
    
}
