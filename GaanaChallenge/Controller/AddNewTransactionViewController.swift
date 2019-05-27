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
    var amountWrtA = [0,0,0,0,0]
    
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

        let total = dataArray.reduce(0) {
            $0 + $1.paidAmountPerTransaction
        }
        
        let eachContri = total/dataArray.count
        
        if eachContri > 0{
            _ = dataArray.map {
                $0.dueAmountPerTransaction = $0.paidAmountPerTransaction - eachContri
            }
            dataArray[0].masterDueAmountPerTransactionWithRespectToA = dataArray[0].dueAmountPerTransaction
            
            // perfrom some business logic
            var amounts = self.dataArray.map { $0.dueAmountPerTransaction }
            self.minCashFlow(arr: &amounts)
            
            // update the Credit or Debit amount for A
            for i in 1..<amountWrtA.count{
                self.dataArray[i].masterDueAmountPerTransactionWithRespectToA = self.amountWrtA[i]
            }
            
            //update overall master due amount with respect to A considering all the transaction
            _ = dataArray.map{
                $0.overallMasterDueAmountWithRespectToA = $0.overallMasterDueAmountWithRespectToA + $0.masterDueAmountPerTransactionWithRespectToA
            }
            
            self.addTransaction()
            
        }
    }
    
}


extension AddNewTransactionViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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

// Peform some logic
// USED GREEDY APPROACH TO MINIMIZED TO NUMBER OF ITERATIONS TO DISTRIBUTE THE MONEY BY A
extension AddNewTransactionViewController{
    
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
    
    
    func getMax(arr: [Int]) -> Int{
        var maxIndex = 0
        for (index,value) in arr.enumerated() where index != 0{
            if value > arr[maxIndex]{
                maxIndex = index
            }
        }
        return maxIndex
    }
    
    func getMin(arr: [Int]) -> Int{
        var minIndex = 0
        for (index,value) in arr.enumerated() where index != 0{
            if value < arr[minIndex]{
                minIndex = index
            }
        }
        return minIndex
    }
    
    func getMin(a: Int, b: Int) -> Int{
        return a < b ? a : b
    }
    
    
    func minCashFlow(arr: inout [Int]){
        
        let maxCreditIndx = getMax(arr: arr)
        let maxDebitIndx = getMin(arr: arr)
        
        if arr[maxCreditIndx] == 0 && arr[maxDebitIndx] == 0{ // all amounts are settled
            return
        }
        
        let minValue = self.getMin(a: arr[maxCreditIndx], b: -arr[maxDebitIndx])
        
        if maxCreditIndx == 0{
            self.amountWrtA[maxDebitIndx] = minValue
        }else if maxDebitIndx == 0{
            self.amountWrtA[maxCreditIndx] = -minValue
        }
        
        arr[maxCreditIndx] -= minValue
        arr[maxDebitIndx] += minValue
        
        print("Person \(maxDebitIndx+1) has paid: \(minValue) to person \(maxCreditIndx+1)")
        
        minCashFlow(arr: &arr)
    }
}

