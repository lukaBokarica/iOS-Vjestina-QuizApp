//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.05.2021..
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LeaderboardDelegate {
    
    @IBOutlet weak var leaderboardTable: UITableView!
    
    var leaderboardResults: [LeaderboardResult] = []
    
    var results: [LeaderboardResult] = []
    
    private let leaderboardPresenter = LeaderboardPresenter(networkService: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()

        leaderboardPresenter.setViewDelegate(leaderboardDelegate: self)

        initialSetup()

        DispatchQueue.main.async {
            self.leaderboardPresenter.getResults()
        }
        
    }

    func initialSetup() {
        leaderboardTable.register(LeaderBoardCellView.nib(), forCellReuseIdentifier: LeaderBoardCellView.identifier)
        leaderboardTable.delegate = self
        leaderboardTable.dataSource = self
        leaderboardTable.backgroundColor = .clear
        
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        
        self.navigationController?.navigationBar.tintColor = .white
        
        let titleItem = UILabel()
        titleItem.text = "Leaderboard"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(25)
        navigationItem.titleView = titleItem
        
        let xSign = UIImage(systemName: "xmark")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: xSign, style: .done,
                                                           target: self, action: #selector(goBack))
        
    }
    
    func setQuiz(quiz: Quiz) {
        leaderboardPresenter.setQuiz(quiz: quiz)
    }
    
    @objc func goBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (leaderboardPresenter.tableView(tableView, numberOfRowsInSection: section))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (leaderboardPresenter.tableView(tableView, cellForRowAt: indexPath))
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return leaderboardPresenter.tableView(tableView, willSelectRowAt: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (leaderboardPresenter.numberOfSections(in: tableView))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return leaderboardPresenter.tableView(tableView, viewForHeaderInSection: section)
    }
    
    func completed() {
        leaderboardTable.reloadData()
    }
}
