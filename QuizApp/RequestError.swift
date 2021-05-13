//
//  RequestError.swift
//  QuizApp
//
//  Created by Pero Bokarica on 11.05.2021..
//

import UIKit

enum RequestError: Error {
    case noDataError
    case decodingError
    case clientError
    case serverError
    case noData
    case dataDecodingError
}
