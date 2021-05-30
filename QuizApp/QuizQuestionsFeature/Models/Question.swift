import UIKit

public struct Question: Codable {

    let id: Int
    let question: String
    let answers: [String]
    let correctAnswer: Int

    enum CodingKeys: String, CodingKey {
        case id
        case question
        case answers
        case correctAnswer = "correct_answer"
    }
}

extension Question {
    init(with entity: CDQuizQuestion) {
        id = Int(bitPattern: entity.id)
        question = entity.question
        answers = entity.answers
        correctAnswer = Int(entity.correctAnswer)
    }
}
