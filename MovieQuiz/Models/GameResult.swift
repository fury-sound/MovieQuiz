//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Valery Zvonarev on 26.06.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func compareRecords (_ previousRecord: GameResult) -> Bool {
        return correct > previousRecord.correct ? true : false
    }
}
