//
//  ListTableViewCell.swift
//  keyboardTest
//
//  Created by RyoNagai on 2021/06/09.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var testTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
