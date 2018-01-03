//
//  HomeFeedCellTableViewCell.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/2/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit

class HomeFeedCell: UITableViewCell {
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var videoViewRatio: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var fireButton: RoundedButton!
    @IBOutlet weak var commentButton: RoundedButton!
    @IBOutlet weak var shareButton: RoundedButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
