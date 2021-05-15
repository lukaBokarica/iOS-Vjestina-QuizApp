//
//  TableViewCell.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.04.2021..
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    @IBOutlet weak var quizNameLabel: UILabel!
    
    @IBOutlet weak var quizDescriptionLabel: UILabel!
    
    @IBOutlet weak var quizDifficultyLabel: UILabel!
        
    static func nib() -> UINib {
            return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        //innerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
