//
//  MainTableViewCell.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderImageView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        borderImageView.layer.borderWidth = 1
        borderImageView.layer.cornerRadius = 10
    }
}
