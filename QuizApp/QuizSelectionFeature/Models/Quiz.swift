import CoreData
import UIKit

struct Quiz: Codable {

    let id: Int
    let title: String
    let description: String
    let category: QuizCategory
    let level: Int
    let imageUrl: String
    let questions: [Question]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case level
        case imageUrl = "image"
        case questions
    }
}

extension Quiz {
    init(with entity: CDQuiz) {
        id = Int(bitPattern: entity.id)
        title = entity.title
        description = entity.quizDescription
        category = QuizCategory.init(rawValue: entity.category)!
        level = Int(entity.level)
        imageUrl = entity.imageUrl
        var newQuestions: [Question] = []
        for cdquestion in entity.questions {
            let question = Question(with: cdquestion as! CDQuizQuestion)
            newQuestions.append(question)
        }
        self.questions = newQuestions
    }
}
