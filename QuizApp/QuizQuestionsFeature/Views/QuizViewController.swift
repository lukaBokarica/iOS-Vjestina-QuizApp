//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 04.05.2021..
//

import UIKit

protocol QuizViewControllerDelegate: AnyObject {
    func answered(answer : Bool)
    func nextClicked()
}

class QuizViewController: UIViewController, QuizViewDelegate {

    private var question : Question
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var qstNumLabel: UILabel!
    
    @IBOutlet weak var firstAnswer: UIButton!
    
    @IBOutlet weak var secondAnswer: UIButton!
    
    @IBOutlet weak var thirdAnswer: UIButton!
    
    @IBOutlet weak var fourthAnswer: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var questionTracker: UIStackView!
    
    weak var delegate: QuizViewControllerDelegate?
    
    let view1 : UIView = UIView()
    
    @IBOutlet weak var subview: UIView!
    
    private let quizViewPresenter = QuizViewPresenter()

    private var buttonArray : [UIButton]
    
    init(question : Question) {
        self.question = question
        quizViewPresenter.setQuestion(question: question)
        buttonArray = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizViewPresenter.setViewDelegate(quizViewDelegate: self)
                
        setupButtonArray()
        
        initialSetup()
    }

    func initialSetup() {
        questionLabel.text = question.question
        setUpButtons()
        nextButton.isHidden = true
        if(quizViewPresenter.getQuestionNumber() == quizViewPresenter.getQuestionCount()) {
            nextButton.setTitle("Show me results!", for: .normal)
        }
        qstNumLabel.text = String(quizViewPresenter.getQuestionNumber()) + "/" + String(quizViewPresenter.getQuestionCount())
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
    
    func setupButtonArray() {
        buttonArray = [firstAnswer, secondAnswer, thirdAnswer, fourthAnswer]
    }
    
    @IBAction func answerClicked(_ sender: UIButton) {
        disableButtons()
        let correctAnswerButton = buttonArray[quizViewPresenter.findCorrectAnswer()!]
        if(correctAnswerButton == sender) {
            sender.backgroundColor = .green.withAlphaComponent(0.6)
            delegate?.answered(answer: true)
        } else {
            sender.backgroundColor = .red.withAlphaComponent(0.6)
            correctAnswerButton.backgroundColor = .green.withAlphaComponent(0.6)
            delegate?.answered(answer: false)
        }
        nextButton.isHidden = false
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        delegate?.nextClicked()
    }
    
    func disableButtons() {
        firstAnswer.isEnabled = false
        secondAnswer.isEnabled = false
        thirdAnswer.isEnabled = false
        fourthAnswer.isEnabled = false
    }
    
    func setInfo(questionNumber : Int, questionCount : Int) {
        quizViewPresenter.setInfo(questionNumber: questionNumber, questionCount: questionCount)
    }
    
    func updateQuestionTracker(answer : Bool, index : Int) {
        let lastAnswer = questionTracker.arrangedSubviews[index]
        switch answer {
        case true:
            lastAnswer.backgroundColor = .green
        default:
            lastAnswer.backgroundColor = .red
        }
    }
    
    func setUpQuestionTracker(answers : [Bool], index : Int) {
        if index > 1 {
            for i in 1...index - 1{
                let subview = UIView()
                let answer = answers[i - 1]
                //print(answers[index - 2])
                switch answer {
                case true:
                    subview.backgroundColor = .green.withAlphaComponent(0.4)
                case false:
                    subview.backgroundColor = .red.withAlphaComponent(0.4)
                }
                subview.layer.cornerRadius = 5
                questionTracker.addArrangedSubview(subview)
            }
        }
        let subview = UIView()
        subview.backgroundColor = .white.withAlphaComponent(0.8)
        subview.layer.cornerRadius = 5
        questionTracker.addArrangedSubview(subview)
        if index <= quizViewPresenter.getQuestionCount() - 1 {
            for _ in index...quizViewPresenter.getQuestionCount() - 1 {
                let subview = UIView()
                subview.backgroundColor = .white.withAlphaComponent(0.4)
                subview.layer.cornerRadius = 5
                questionTracker.addArrangedSubview(subview)
            }
        }
    }
}
