//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 26.06.2024.
//

import Foundation

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date

    func compareRecords (_ previousRecord: GameResult) -> Bool {
        return correct > previousRecord.correct ? true : false
    }
}
