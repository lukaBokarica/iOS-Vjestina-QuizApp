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
}
