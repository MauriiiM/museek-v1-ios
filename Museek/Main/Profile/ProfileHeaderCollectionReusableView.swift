//
//  ProfileHeaderCollectionReusableView.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/5/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import SDWebImage

/**
 View of header cell of collection view controller for any usser's profile. View details
 are determined by global user var.
 */
class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet fileprivate weak var username: UILabel!
    @IBOutlet weak var supportersCountLabel: UILabel!
    @IBOutlet weak var supportingCountLabel: UILabel!
    @IBOutlet weak var supportButton: RoundedButton!
    
    var user: User?{
        didSet{ updateView() }
    }
    
    @IBAction func supportButtonPressed(_ sender: Any) {
        Api.Support.supportUser(withID: user!.id!)
    }
    
    func updateView(){
        username.text = user?.username
        if let imageURLString = user?.profileImageURL{
            let imageURL = URL(string: imageURLString)
            profileImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "default user photo"))
        }
        if user?.id == Api.User.CURRENT_USER?.uid {
            supportButton.titleLabel?.text = "Edit Profile"
        }
    }
}
