//
//  AllTxnCell.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import UIKit

class AllTxnCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.amountLabel.textColor = UIColor.white
    }
    
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setUp(userObj: User){
        self.userNameLabel.text = userObj.name
        let amount = userObj.overallMasterDueAmountWithRespectToA
        if amount > 0{
            self.amountLabel.text = "+\(amount)"
            self.amountLabel.textColor = UIColor.green
        }else if amount < 0{
            self.amountLabel.text = "\(amount)"
            self.amountLabel.textColor = UIColor.red
        }else{
            self.amountLabel.text = "\(amount)"
        }
    }
    
}
