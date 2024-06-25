//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 26.06.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
//    func store(_ result: GameResult)
}
