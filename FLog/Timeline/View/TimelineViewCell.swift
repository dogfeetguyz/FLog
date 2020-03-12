//
//  MainTableViewCell.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class TimelineViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var borderImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderImageView.layer.cornerRadius = 5
        borderImageView.layer.shadowColor = UIColor.black.cgColor
        borderImageView.layer.shadowOpacity = 0.1
        borderImageView.layer.shadowOffset = CGSize(width: 3, height: 10)
        borderImageView.layer.shadowRadius = 5
        borderImageView.layer.masksToBounds = false
        
    }
}
