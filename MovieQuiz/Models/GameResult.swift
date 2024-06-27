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
//    var compareRecords: (GameResult) -> Int
//
//    init(correct: Int, total: Int, date: Date, compareRecords: @escaping (GameResult) -> Int) {
//        self.correct = correct
//        self.total = total
//        self.date = date
//        self.compareRecords = compareRecords
//    }
    func compareRecords (_ previousRecord: GameResult) -> Bool {
        return correct > previousRecord.correct ? true : false
    }
}
