//
//  ClientCell.swift
//  Payment_System
//
//  Created by Iliyan on 5/26/17.
//  Copyright © 2017 Iliyan. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell {

    
    
    @IBOutlet weak var docNum: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var applied: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
