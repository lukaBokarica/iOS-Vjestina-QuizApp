//
//  StartQuizViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 05.05.2021..
//

import UIKit

class StartQuizViewController: UIViewController, StartQuizViewDelegate {
        
    @IBOutlet weak var quizImageView: UIImageView!
    
    @IBOutlet weak var quizName: UILabel!
    
    private let startQuizPresenter = StartQuizPresenter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startQuizPresenter.setViewDelegate(startQuizViewDelegate: self)
        
        initialSetup()
    }
    
    func setQuiz(quiz: Quiz) {
        startQuizPresenter.setQuiz(quiz: quiz)
    }
    
    func initialSetup() {
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        
        let backArrow = UIImage(systemName: "chevron.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backArrow, style: .done,
                                                           target: self, action: #selector(goBack))
        
        self.navigationController?.navigationBar.tintColor = .white
        
        let titleItem = UILabel()
        titleItem.text = "PopQuiz"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(20)
        navigationItem.titleView = titleItem
        
        quizName.text = startQuizPresenter.getQuiz().title
        setImage()
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func startQuizButtonClicked(_ sender: UIButton) {
        let vc = startQuizPresenter.executeQuizStarting()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setImage() {
        let imageUrlString = startQuizPresenter.getQuiz().imageUrl
        
        guard let imageUrl:URL = URL(string: imageUrlString) else {
            return
        }
                
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global().async { [weak self] in
                    
            guard let self = self else { return }
                        
            guard let imageData = try? Data(contentsOf: imageUrl) else {
                return
            }
                        
            // When from a background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                
                self.quizImageView.image = image
                
                self.quizImageView.layer.cornerRadius = 30
                self.quizImageView.clipsToBounds = true
            }
        }
    }
}
