//
//  QuizResultPresenter.swift
//  QuizApp
//
//  Created by Pero Bokarica on 13.05.2021..
//

import UIKit

protocol QuizResultViewDelegate: NSObjectProtocol {
    
}

class QuizResultPresenter: NSObject {
    
    weak private var quizResultViewDelegate : QuizResultViewDelegate?

    private var answers : [Bool]?

    var quiz: Quiz?
    
    func setViewDelegate(quizResultViewDelegate:QuizResultViewDelegate?) {
        self.quizResultViewDelegate = quizResultViewDelegate
    }
    
    func setAnswers(answers: [Bool]) {
        self.answers = answers
    }
    
    func setQuiz(quiz: Quiz) {
        self.quiz = quiz
    }
    
    func getQuiz() -> Quiz? {
        return quiz
    }
    
    func countTrue() -> Int {
        var count = 0
        for answer in answers! {
            if answer == true {
                count = count + 1
            }
        }
        return count
    }
    
}
