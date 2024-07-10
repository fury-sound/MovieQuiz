//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 26.06.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correctTotal
        case bestGame
        case gamesCount
    }
    
    // total number of correct answers for ALL games
    private var correctTotal: Int {
        get {
            storage.integer(forKey: Keys.correctTotal.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctTotal.rawValue)
        }
    }
    
    // total number of ALL games
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // results as correct answers for the best game: No of corrects answers, total number of answers in the game, formatted date (date and time to make that record)
    var bestGame: GameResult {
        get {
            // returning best game result as GameResult value
            GameResult(correct: storage.integer(forKey: "correct"), total: storage.integer(forKey: "total"), date: storage.object(forKey: "date") as? Date ?? Date())
        }
        set {
            // storing each property for GameResult under the separate key in UserDefaults
            storage.set(newValue.correct, forKey: "correct")
            storage.set(newValue.total, forKey: "total")
            storage.set(newValue.date, forKey: "date")
        }
    }
    
    // total accuracy percentage for ALL games
    var totalAccuracy: Double {
        get {
            storage.double(forKey: "totalAccuracy")
        }
        set {
            storage.set(newValue, forKey: "totalAccuracy")
        }
    }
    
    //storage function: storing and updating TOTAL values and replacing best game results (if no of correct answers in that game is better)
    func store(correct count: Int, total amount: Int) {
        correctTotal += count
        gamesCount +=  1
        totalAccuracy = (Double(correctTotal)/Double(10*gamesCount))*100
        
        let bestGameTemp = GameResult(correct: count, total: amount, date: Date())
        if bestGameTemp.compareRecords(bestGame) {
            bestGame = GameResult(correct: count, total: amount, date: Date())
        }
    }
}
