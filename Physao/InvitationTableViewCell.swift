//
//  InvitationTableViewCell.swift
//  testTableView
//
//  Created by Weiqi Wei on 15/11/27.
//  Copyright © 2015年 Physaologists. All rights reserved.
//

import UIKit

class InvitationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var refuseButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
