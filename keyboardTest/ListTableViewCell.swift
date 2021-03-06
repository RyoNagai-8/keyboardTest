//
//  ListTableViewCell.swift
//  keyboardTest
//
//  Created by RyoNagai on 2021/06/09.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func checkBoxToggle(sender: ListTableViewCell)
    func editTextField(sender: ListTableViewCell)
    func editTextBegin(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var testTextField: UITextField!
    @IBOutlet weak var checkBoxButton: UIButton!
    weak var delegate: ListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
    
    @IBAction func editText(_ sender: UITextField) {
        delegate?.editTextField(sender: self)
    }
    
    @IBAction func editTextBegin(_ sender: UITextField) {
        delegate?.editTextBegin(sender: self)
    }
    
}
