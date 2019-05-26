//
//  ViewController.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataArray = [User]()
    var transactionArray = [Transaction]()

    @IBOutlet weak var tablewView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "ALL TRX", style: .plain, target: self, action: #selector(pushTransaction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
        
        self.tablewView.dataSource = self
        self.tablewView.delegate = self
        self.tablewView.backgroundColor = .black
        self.tablewView.registerCellNib(AllTxnCell.self)
        self.tablewView.tableFooterView = UIView()
        initial()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initial(){
        
        self.dataArray = getUserData()
        self.transactionArray = getTransData()
        
        if self.dataArray.isEmpty{
            dataArray = [User]()
            let obj1 = User(name: "A", id: 0)
            dataArray.append(obj1)
            
            let obj2 = User(name: "B", id: 1)
            dataArray.append(obj2)
            let obj3 = User(name: "C", id: 2)
            dataArray.append(obj3)
            
            let obj4 = User(name: "D", id: 3)
            dataArray.append(obj4)
            let obj5 = User(name: "E", id: 4)
            dataArray.append(obj5)
        }
        
    }
    
    @objc func push(){
        let vc = AddNewTransactionViewController(nibName: "AddNewTransactionViewController", bundle: nil)
        vc.transactionList = transactionArray
        _ = dataArray.map{
            $0.dueAmountPerTransaction = 0
            $0.paidAmountPerTransaction = 0
            $0.masterDueAmountPerTransactionWithRespectToA = 0
        }
        vc.dataArray = dataArray
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushTransaction(){
        let vc = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        vc.transactionList = transactionArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func persistData(){
        clearUserData()
        clearTransactionData()
        saveUserData(list: self.dataArray)
        saveTransactionData(list: transactionArray)
    }
}


extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tablewView.dequeueReusableCell(withIdentifier: "AllTxnCell") as! AllTxnCell
        cell.setUp(userObj: dataArray[indexPath.row])
        return cell
    }
}

extension ViewController: saveDelegate{
    
    func didSave(data: [User], transactionList: [Transaction]) {
        dataArray = data
        transactionArray = transactionList
        self.persistData()
        self.tablewView.reloadData()
    }
    
}
