//
//  ContactTableViewCell.swift
//  TestPhone
//
//  Created by Vitaliy Kozlov on 04/04/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import UIKit
import Kingfisher

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    
    func configure (data : Contact){
        nameLabel.text = data.name
        phoneLabel.text = data.phone
        var tags = ""
        var isFirst = true
        for item in data.tags! {
            if isFirst{
                tags += item
                isFirst = false
            }else {
                tags = tags + ", " + item
            }
        }
        tagsLabel.text = tags
        let url = URL (string: data.picture ?? "")
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        contactImageView.kf.indicatorType = .activity
        contactImageView.kf.setImage(with: url, placeholder: UIImage(named: "noavatar"), options: [.processor(processor)])
        
        
    }
}
