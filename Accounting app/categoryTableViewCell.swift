//
//  categoryTableViewCell.swift
//  Accounting app
//
//  Created by WEBSYSTEM-MAC31 on 2022/05/25.
//

import UIKit

class categoryTableViewCell: UITableViewCell {

    @IBOutlet weak var spend: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
