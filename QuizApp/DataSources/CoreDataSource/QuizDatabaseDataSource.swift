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
    
    private var quizzesViewDelegate: QuizzesViewDelegate?
    
    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }
    
    func setQuizzesViewDelegate(delegate: QuizzesViewDelegate) {
        self.quizzesViewDelegate = delegate
    }
    
    func fetchQuizzesFromCoreData() -> [Quiz] {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        do {
            let quizzes = try coreDataContext.fetch(request).map { Quiz(with: $0) }
            self.quizzesViewDelegate?.completed(quizzes: quizzes)
            return quizzes
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
    }
    
    func saveQuizzes(quizzes: [Quiz]) {
        let quizEntity = NSEntityDescription.entity(forEntityName: "CDQuiz", in: coreDataContext)!
        let questionEntity = NSEntityDescription.entity(forEntityName: "CDQuizQuestion", in: coreDataContext)!

        for quiz in quizzes {
            let newQuiz = CDQuiz(entity: quizEntity, insertInto: coreDataContext)
            newQuiz.id = Int16(quiz.id)
            newQuiz.title = quiz.title
            newQuiz.quizDescription = quiz.description
            newQuiz.level = Int16(quiz.level)
            newQuiz.imageUrl = quiz.imageUrl
            newQuiz.category = quiz.category.rawValue
            //provjeriti jel ovo radi dobro!!
            let questions = saveQuestions(questions: quiz.questions, questionEntity: questionEntity, quiz: newQuiz)
            newQuiz.questions = NSSet(array: questions)
        }
        do {
            try coreDataContext.save()
            print("Success while saving quizzes and questions to core data!")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func saveQuestions(questions: [Question], questionEntity: NSEntityDescription, quiz: CDQuiz) -> [CDQuizQuestion] {
        var quizQuestions: [CDQuizQuestion] = []
        for question in questions {
            let newQuestion = CDQuizQuestion(entity: questionEntity, insertInto: coreDataContext)
            newQuestion.id = Int16(question.id)
            newQuestion.question = question.question
            newQuestion.answers = question.answers
            newQuestion.correctAnswer = Int16(question.correctAnswer)
            newQuestion.quiz = quiz
            quizQuestions.append(newQuestion)
        }
        return quizQuestions
    }
    
    func deleteQuizzes() {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        do {
            let quizzes = try coreDataContext.fetch(request)
            
            for quiz in quizzes {
                coreDataContext.delete(quiz)
            }
            try? coreDataContext.save()
        } catch _ as NSError {
            print("Error while deleting quizzes from CoreData!")
        }
    }
}
