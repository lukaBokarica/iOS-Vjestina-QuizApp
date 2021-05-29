//
//  QuizRepositoryProtocol.swift
//  QuizApp
//
//  Created by Luka Bokarica on 29.05.2021..
//

import UIKit

protocol QuizRepositoryProtocol {
    func fetchData() -> [Quiz]
    func fetchRemoteData() -> [Quiz]
    func fetchLocalData() -> [Quiz]
}
