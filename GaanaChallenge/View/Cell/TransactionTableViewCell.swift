//
//  TransactionTableViewCell.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var tnrxLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUp(transactionObj: Transaction){
        self.tnrxLabel.text = "Transaction \(transactionObj.id) : \(transactionObj.createdDatatime)"
        if transactionObj.person1Owes < 0{
            self.label1.isHidden = false
            self.label1.text = "A owes \(-transactionObj.person1Owes)"
        }
        if transactionObj.person2Owes < 0{
            self.label2.isHidden = false
            self.label2.text = "B owes \(-transactionObj.person2Owes)"
        }
        if transactionObj.person3Owes < 0{
            self.label3.isHidden = false
            self.label3.text = "C owes \(-transactionObj.person3Owes)"
        }
        if transactionObj.person4Owes < 0{
            self.label4.isHidden = false
            self.label4.text = "D owes \(-transactionObj.person4Owes)"
        }
        if transactionObj.person5Owes < 0{
            self.label5.isHidden = false
            self.label5.text = "E owes \(-transactionObj.person5Owes)"
        }
        
    }
    
}
