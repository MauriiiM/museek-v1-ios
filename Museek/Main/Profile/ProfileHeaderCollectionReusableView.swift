//
//  ProfileHeaderCollectionReusableView.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/5/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var username: UILabel!
    
    
    
    func updateView(){
        API.USER.REF_CURRENT_USER?.observeSingleEvent(of: .value) {
            snapshot in
            if let dictionary = snapshot.value as? [String: Any]{
                let user = User.transformUser(with: dictionary)
                if let profileImageUrl = user.profileImageURL{
                    let profileImage = URL(string: profileImageUrl)
                    self.profileImage.sd_setImage(with: profileImage)
                }
                self.username.text = user.username
            }
        }
    }
}
