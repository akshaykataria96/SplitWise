//
//  TransactionViewController.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var transactionList = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "All Tx Info"
        self.tableView.backgroundColor = .black
        initialSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetUp() {
        self.tableView.registerCellNib(TransactionTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }
    
}

extension TransactionViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(transactionList.count > 0){
            self.tableView?.backgroundView = nil
        } else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView!.bounds.size.width, height: self.tableView!.bounds.size.height))
            noDataLabel.numberOfLines = 1
            noDataLabel.text          = "No Data Available"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            self.tableView?.backgroundView  = noDataLabel
            self.tableView?.separatorStyle  = .none
        }
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as! TransactionTableViewCell
        cell.setUp(transactionObj: transactionList[indexPath.row])
        return cell
    }
}
