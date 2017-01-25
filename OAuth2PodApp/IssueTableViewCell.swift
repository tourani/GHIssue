//
//  ProfileTableViewCell.swift
//  OAuth2PodApp
//
//  Created by Sanjay on 1/23/17.

//

import UIKit

class IssueTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bodyLabel: UITextView!
    @IBOutlet weak var lockedButton: UIButton!
    @IBOutlet weak var unlockedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
