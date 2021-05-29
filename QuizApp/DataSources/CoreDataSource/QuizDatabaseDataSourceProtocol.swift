//
//  QuizDatabaseDataSourceProtocol.swift
//  QuizApp
//
//  Created by Luka Bokarica on 28.05.2021..
//

import UIKit

protocol QuizDatabaseDataSourceProtocol {
    func fetchQuizzesFromCoreData() -> [Quiz]
    func saveQuizzes(quizzes:[Quiz])
}
