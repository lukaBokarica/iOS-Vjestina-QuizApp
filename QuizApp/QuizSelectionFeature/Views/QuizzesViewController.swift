//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.04.2021..
//

import UIKit

class QuizzesViewController: UIViewController, QuizzesViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var funFactLabel: UILabel!
    
    @IBOutlet weak var funFactTitleLabel: UILabel!
    
    @IBOutlet weak var lighbulbImage: UIImageView!
    
    @IBOutlet weak var quizTable: UITableView!

    @IBOutlet weak var errorLabel: UILabel!
        
    @IBOutlet weak var networkSign: UIImageView!
    
    private let quizzesPresenter = QuizzesPresenter(networkService: NetworkService())
    
    @IBAction func getQuizClicked(_ sender: UIButton) {
        quizzesPresenter.fetchQuizzes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizzesPresenter.setViewDelegate(quizzesViewDelegate: self)
        
        quizzesPresenter.fetchQuizzes()
        
    }
    
    func initialSetup() {
        quizTable.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        quizTable.delegate = self
        quizTable.dataSource = self
        quizTable.backgroundColor = .clear
        quizTable.isHidden = true
        quizTable.rowHeight = 100
        
        errorLabel.isHidden = true
        networkSign.isHidden = true
        funFactLabel.isHidden = true
        lighbulbImage.isHidden = true
        funFactTitleLabel.isHidden = true
        
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        
        let titleItem = UILabel()
        titleItem.text = "PopQuiz"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(20)
        navigationItem.titleView = titleItem
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzesPresenter.numberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesPresenter.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return quizzesPresenter.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return quizzesPresenter.tableView(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        return quizzesPresenter.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func pushStartQuiz(startQuizController: StartQuizViewController) {
        self.navigationController?.pushViewController(startQuizController, animated: true)
    }
    
    func showErrorLabel() {
        DispatchQueue.main.async { [self] in
            quizTable.isHidden = true
            funFactLabel.isHidden = true
            lighbulbImage.isHidden = true
            funFactTitleLabel.isHidden = true
            
            errorLabel.isHidden = false
            networkSign.isHidden = false
        }
    }
    
    func completed(quizzes: [Quiz]) {
        quizzesPresenter.setQuizzes(quizzes: quizzes)

        quizTable.reloadData()
        initialSetup()
        
        errorLabel.isHidden = true
        networkSign.isHidden = true
        
        quizTable.isHidden = false
        funFactLabel.isHidden = false
        lighbulbImage.isHidden = false
        funFactTitleLabel.isHidden = false
        let funFactNum = quizzesPresenter.getFunFact(quizzes: quizzes)
        funFactLabel.text = "There are " + String(funFactNum) +
        " quizzes that contain the word NBA."
    }
}
