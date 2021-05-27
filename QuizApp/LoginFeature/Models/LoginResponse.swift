//
//  LoginResponse.swift
//  QuizApp
//
//  Created by Pero Bokarica on 12.05.2021..
//

import UIKit

struct LoginResponse: Codable {
    
    var token : String
    var userId : Int

    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }
}
