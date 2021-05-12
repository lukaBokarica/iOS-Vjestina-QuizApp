//
//  Result.swift
//  QuizApp
//
//  Created by Pero Bokarica on 11.05.2021..
//

import UIKit

enum Result<Success, Failure> where Failure : Error {
    
    /// A success, storing a `Success` value.
    case success(Success)
    
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}
