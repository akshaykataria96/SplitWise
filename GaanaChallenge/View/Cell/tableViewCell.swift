//
//  tableViewCell.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setUp(userObj: User){
        self.label.text = userObj.name
        self.textField.isUserInteractionEnabled = true
        self.textField.keyboardType = .numberPad
        self.textField.tag = userObj.id
    }
    
}
