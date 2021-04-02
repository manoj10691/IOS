//
//  VotingTableViewCell.swift
//  VPortals
//
//  Created by Nadeem Khan on 16/01/21.
//

import UIKit

class SurveyNextTableViewCell: UITableViewCell {
    
        @IBOutlet weak var vTitle: UILabel!
        @IBOutlet weak var vRadio: UIImageView!
        @IBOutlet weak var vBio: UIImageView!
        @IBOutlet weak var mainBackground: UIView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
