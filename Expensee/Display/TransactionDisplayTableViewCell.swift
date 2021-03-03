//
//  TransactionDisplayTableViewCell.swift
//  Expensee
//
//  Created by temp on 26/02/21.
//

import UIKit

class TransactionDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLabel.textColor = UIColor.lightGray
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
