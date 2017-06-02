//
//  TableViewCell.swift
//  Payment_System
//
//  Created by Iliyan on 5/25/17.
//  Copyright © 2017 Iliyan. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
   //Field names in TABLE
    @IBOutlet weak var idField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var refField: UILabel!
    @IBOutlet weak var balanceField: UILabel!
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
