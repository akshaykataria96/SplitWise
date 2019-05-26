//
//  AddNewTransactionViewController.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import UIKit

protocol saveDelegate: class {
    func didSave(data: [User], transactionList: [Transaction])
}

class AddNewTransactionViewController: UIViewController {

    weak var delegate: saveDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func saved(_ sender: Any) {
        save()
        self.navigationController?.popViewController(animated: true)
        self.delegate?.didSave(data: dataArray, transactionList: transactionList)
    }
    
    
    var dataArray = [User]()
    var transactionList = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add New Tx"
        self.tableView.backgroundColor = .black
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerCellNib(tableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save() {
        //        var total = 0
        //        for obj in dataArray {
        //            total = total + obj.paidAmountPerTransaction
        //        }
        let total = dataArray.reduce(0) {
            $0 + $1.paidAmountPerTransaction
        }
        
        let eachContri = total/dataArray.count
        
        if eachContri > 0 {
            _ = dataArray.map {
                $0.dueAmountPerTransaction = $0.paidAmountPerTransaction - eachContri
            }
            dataArray[0].masterDueAmountPerTransactionWithRespectToA = dataArray[0].dueAmountPerTransaction
            
            //calculation with respect to A
            if dataArray[0].masterDueAmountPerTransactionWithRespectToA < 0 {
                // A has to give money back to others
                _ = dataArray.enumerated().map{ (index, element) in
                    if index > 0 {
                        if element.dueAmountPerTransaction > 0 {
                            // considering person who has +ve due amount, means A has to give money to those people only
                            if element.dueAmountPerTransaction <= -dataArray[0].masterDueAmountPerTransactionWithRespectToA{
                                let t = element.dueAmountPerTransaction
                                element.masterDueAmountPerTransactionWithRespectToA = element.masterDueAmountPerTransactionWithRespectToA - t // A is giving back to that person
                                dataArray[0].masterDueAmountPerTransactionWithRespectToA = dataArray[0].masterDueAmountPerTransactionWithRespectToA + t // also updating the A's due amount
                                debugPrint("\(index) ---> \(element.masterDueAmountPerTransactionWithRespectToA)  ----- \(dataArray[0].masterDueAmountPerTransactionWithRespectToA)")
                                
                                
                            }else if element.dueAmountPerTransaction > -dataArray[0].masterDueAmountPerTransactionWithRespectToA{
                                let t = dataArray[0].masterDueAmountPerTransactionWithRespectToA
                                element.masterDueAmountPerTransactionWithRespectToA = element.masterDueAmountPerTransactionWithRespectToA + t
                                dataArray[0].masterDueAmountPerTransactionWithRespectToA = dataArray[0].masterDueAmountPerTransactionWithRespectToA - t
                                debugPrint("\(index) ---> \(element.masterDueAmountPerTransactionWithRespectToA)  ----- \(dataArray[0].masterDueAmountPerTransactionWithRespectToA)")
                                
                            }
                        }
                        
                    }
                    
                }
                
                
            }else if dataArray[0].masterDueAmountPerTransactionWithRespectToA > 0 {
                // A has will get money back from others
                _ = dataArray.enumerated().map{ (index, element) in
                    if index > 0 {
                        if element.dueAmountPerTransaction < 0 {
                            // considering person who has -ve due amount, means A will get money from those people only
                            if  dataArray[0].masterDueAmountPerTransactionWithRespectToA <= -element.dueAmountPerTransaction{
                                let t = dataArray[0].masterDueAmountPerTransactionWithRespectToA
                                element.masterDueAmountPerTransactionWithRespectToA = element.masterDueAmountPerTransactionWithRespectToA + t
                                dataArray[0].masterDueAmountPerTransactionWithRespectToA = dataArray[0].masterDueAmountPerTransactionWithRespectToA - t //A is getting back from that person
                                debugPrint("\(index) ---> \(element.masterDueAmountPerTransactionWithRespectToA)  ----- \(dataArray[0].masterDueAmountPerTransactionWithRespectToA)")
                                
                            }else if dataArray[0].masterDueAmountPerTransactionWithRespectToA > -element.dueAmountPerTransaction {
                                let t = element.dueAmountPerTransaction
                                element.masterDueAmountPerTransactionWithRespectToA = element.masterDueAmountPerTransactionWithRespectToA - t
                                dataArray[0].masterDueAmountPerTransactionWithRespectToA = dataArray[0].masterDueAmountPerTransactionWithRespectToA + t
                                debugPrint("\(index) ---> \(element.masterDueAmountPerTransactionWithRespectToA)  ----- \(dataArray[0].masterDueAmountPerTransactionWithRespectToA)")
                                
                                
                            }
                        }
                        
                    }
                    
                }
            }
            
            
            //update overall master due amount with respect to A considering all the transaction
            _ = dataArray.map{
                $0.overallMasterDueAmountWithRespectToA = $0.overallMasterDueAmountWithRespectToA + $0.masterDueAmountPerTransactionWithRespectToA
            }
            
            self.addTransaction()
        }
        
    }
    
    func addTransaction(){
        //update transaction list
        let transaction = Transaction()
        transaction.id = transactionList.count + 1
        transaction.createdDatatime = Helper.getCurrentDate(format: "dd-MM-yyyy HH:mm:ss")
        transaction.person1Owes =  dataArray[0].dueAmountPerTransaction
        transaction.person2Owes =  dataArray[1].dueAmountPerTransaction
        transaction.person3Owes =  dataArray[2].dueAmountPerTransaction
        transaction.person4Owes =  dataArray[3].dueAmountPerTransaction
        transaction.person5Owes =  dataArray[4].dueAmountPerTransaction
        transactionList.append(transaction)
    }
    
}


extension AddNewTransactionViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! tableViewCell
        cell.setUp(userObj: dataArray[indexPath.row])
        cell.textField.delegate = self
        return cell
    }
}

extension AddNewTransactionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText{
            dataArray[textField.tag].paidAmountPerTransaction = Int(textField.text!) ?? 0
            self.tableView.reloadData()
        }
    }
}

