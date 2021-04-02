//
//  VotingTableViewCell.swift
//  VPortals
//
//  Created by Nadeem Khan on 16/01/21.
//

import UIKit

class VotingTableViewCell: UITableViewCell {
    
        @IBOutlet weak var vTitle: UILabel!
        @IBOutlet weak var vDateTime: UILabel!
        @IBOutlet weak var vDaysAgo: UILabel!
        @IBOutlet weak var mainBackground: UIView!
        @IBOutlet weak var vAddress: UILabel!
        @IBOutlet weak var vUnit: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
