//
//  QuizDatabaseDataSource.swift
//  QuizApp
//
//  Created by Luka Bokarica on 28.05.2021..
//
import CoreData
import UIKit

class QuizDatabaseDataSource: QuizDatabaseDataSourceProtocol {
    
    private let coreDataContext: NSManagedObjectContext

    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }
    
    func fetchQuizzesFromCoreData() -> [Quiz] {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        do {
            return try coreDataContext.fetch(request).map { Quiz(with: $0) }
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
    }
    
    func saveQuizzes(quizzes: [Quiz]) {
            for quiz in quizzes {
                let newQuiz = NSEntityDescription.insertNewObject(forEntityName: "CDQuiz", into: coreDataContext)
                newQuiz.setValue(Int(quiz.id), forKey: "id")
                newQuiz.setValue(quiz.title, forKey: "title")
                newQuiz.setValue(quiz.description, forKey: "quizDescription")
                newQuiz.setValue(quiz.category, forKey: "category")
                newQuiz.setValue(quiz.imageUrl, forKey: "imageUrl")
                newQuiz.setValue(quiz.level, forKey: "level")
                //provjeriti jel ovo radi dobro!!!
                saveQuestions(questions: quiz.questions)
                //newQuiz.setValue(NSSet.init(object: quiz.questions), forKey: "questions")
            }
            do {
                try coreDataContext.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }
    }
    
    func saveQuestions(questions: [Question]) {
        for question in questions {
            let newQuestion = NSEntityDescription.insertNewObject(forEntityName: "CDQuizQuestion", into: coreDataContext)
            newQuestion.setValue(Int(question.id), forKey: "id")
            newQuestion.setValue(question.answers, forKey: "answers")
            newQuestion.setValue(question.correctAnswer, forKey: "correctAnswer")
            newQuestion.setValue(question.question, forKey: "question")
            //newQuestion.setValue(quiz, forKey: "quiz")
        }
        do {
            try coreDataContext.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
    }
}
