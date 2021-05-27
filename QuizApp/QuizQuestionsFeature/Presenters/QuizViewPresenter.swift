//
//  QuizViewPresenter.swift
//  QuizApp
//
//  Created by Pero Bokarica on 13.05.2021..
//

import UIKit

protocol QuizViewDelegate: NSObjectProtocol {

}

class QuizViewPresenter {
    
    weak private var quizViewDelegate : QuizViewDelegate?
    
    private var question : Question?

    var questionNumber : Int?
    
    var questionCount : Int?
    
    func setQuestion(question: Question) {
        self.question = question
    }
    
    func setViewDelegate(quizViewDelegate:QuizViewDelegate?) {
        self.quizViewDelegate = quizViewDelegate
    }
    
    func getQuestionNumber() -> Int {
        return questionNumber!
    }
    
    func getQuestionCount() -> Int {
        return questionCount!
    }
    
    func findCorrectAnswer() -> Int? {
        return question?.correctAnswer
    }
    
    func setInfo(questionNumber : Int, questionCount : Int) {
        self.questionNumber = questionNumber
        self.questionCount = questionCount
    }
}
