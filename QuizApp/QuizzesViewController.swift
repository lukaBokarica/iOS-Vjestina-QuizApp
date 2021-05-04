//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.04.2021..
//

import UIKit

class QuizzesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var funFactLabel: UILabel!
    
    @IBOutlet weak var quizTable: UITableView!
    
    var quizzesByCategory = Dictionary<QuizCategory,[Quiz]>()
        
    @IBAction func getQuizClicked(_ sender: UIButton) {
        let ds = DataService()
        let quizzes = ds.fetchQuizes()
        quizzesByCategory = Dictionary(grouping: quizzes) { (quiz) -> QuizCategory in
            return quiz.category
        }
        quizTable.reloadData()
        quizTable.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTable.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        quizTable.delegate = self
        quizTable.dataSource = self
        quizTable.backgroundColor = .clear
        quizTable.isHidden = true
        let ds = DataService()
        let quizzes = ds.fetchQuizes()
        quizzesByCategory = Dictionary(grouping: quizzes) { (quiz) -> QuizCategory in
            return quiz.category
        }
        
        let funFactNum = getFunFact(quizzes: quizzes)
        funFactLabel.text = "There are " + String(funFactNum) +
            " quizzes that contain the word NBA."
        getCategories(quizzes: quizzes)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzesByCategory.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let quizCat = Array(quizzesByCategory.keys)[section]
        return quizzesByCategory[quizCat]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCell.identifier,
            for: indexPath) as! TableViewCell
        let quizCat = Array(quizzesByCategory.keys)[indexPath.section]
        cell.quizNameLabel.text = quizzesByCategory[quizCat]![indexPath.row].title
        cell.quizDescriptionLabel.text = quizzesByCategory[quizCat]![indexPath.row].description
        cell.quizDifficultyLabel!.text! = "Difficulty: " + String(quizzesByCategory[quizCat]![indexPath.row].level)
        return cell
    }
    
    
    func getCategories(quizzes : [Quiz]) {
        var categories = Set<QuizCategory>()
        
        for quiz in quizzes {
            categories.insert(quiz.category)
        }
    }
    
    func getFunFact(quizzes : [Quiz]) -> Int {
        var stringAppearanceCounter = 0
        for quiz in quizzes {
            let quizQuestions = quiz.questions
            for question in quizQuestions {
                if(question.question.contains("NBA")) {
                    stringAppearanceCounter += 1
                }
            }
        }
        return stringAppearanceCounter
    }
}
