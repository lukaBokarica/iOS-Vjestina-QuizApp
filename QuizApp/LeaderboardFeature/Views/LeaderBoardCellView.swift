//
//  LeaderBoardCellView.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.05.2021..
//

import UIKit

class LeaderBoardCellView: UITableViewCell {

    static let identifier = "LeaderBoardCellView"

    @IBOutlet weak var userRankLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userScoreLabel: UILabel!
    
    static func nib() -> UINib {
            return UINib(nibName: "LeaderBoardCellView", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
