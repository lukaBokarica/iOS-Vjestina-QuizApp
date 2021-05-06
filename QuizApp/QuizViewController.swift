//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Pero Bokarica on 04.05.2021..
//

import UIKit

class QuizViewController: UIViewController {

    private var question : Question
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var firstAnswer: UIButton!
    
    @IBOutlet weak var secondAnswer: UIButton!
    
    @IBOutlet weak var thirdAnswer: UIButton!
    
    @IBOutlet weak var fourthAnswer: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    init(question : Question) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question.question
        setUpButtons()
        nextButton.isHidden = true
    }

    
    func getQuestion() -> Question {
        return question
    }
    
    func setUpButtons() {
        firstAnswer.setTitle(question.answers[0], for: .normal)
        firstAnswer.backgroundColor = firstAnswer.backgroundColor?.withAlphaComponent(0.3)
        secondAnswer.setTitle(question.answers[1], for: .normal)
        secondAnswer.backgroundColor = secondAnswer.backgroundColor?.withAlphaComponent(0.3)
        thirdAnswer.setTitle(question.answers[2], for: .normal)
        thirdAnswer.backgroundColor = thirdAnswer.backgroundColor?.withAlphaComponent(0.3)
        fourthAnswer.setTitle(question.answers[3], for: .normal)
        fourthAnswer.backgroundColor = fourthAnswer.backgroundColor?.withAlphaComponent(0.3)
    }
    
    @IBAction func answerClicked(_ sender: UIButton) {
        disableButtons()
        let answer = sender.titleLabel?.text
        if(answer == question.answers[question.correctAnswer]) {
            sender.backgroundColor = .green.withAlphaComponent(0.3)
        }
        else {
            sender.backgroundColor = .red
            let correctAnswerButton = findCorrectAnswer()
            correctAnswerButton?.backgroundColor = .green.withAlphaComponent(0.3)
        }
        nextButton.isHidden = false
    }
    
    
    @IBAction func nextClicked(_ sender: UIButton) {
        //go to next page
    }
    
    func disableButtons() {
        firstAnswer.isEnabled = false
        secondAnswer.isEnabled = false
        thirdAnswer.isEnabled = false
        fourthAnswer.isEnabled = false
    }
    
    func findCorrectAnswer() -> UIButton? {
        switch question.answers[question.correctAnswer] {
        case firstAnswer.titleLabel?.text:
            return firstAnswer
        case secondAnswer.titleLabel?.text:
            return secondAnswer
        case thirdAnswer.titleLabel?.text:
            return thirdAnswer
        case fourthAnswer.titleLabel?.text:
            return fourthAnswer
        default:
            print("no correct answer")
        }
        return nil
    }
    
}
