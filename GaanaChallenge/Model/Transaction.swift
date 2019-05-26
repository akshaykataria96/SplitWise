//
//  Transaction.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Transaction{
    var id: Int = 0
    var createdDatatime: String = ""
    //var involvedUserList = [User]()
    var person1Owes: Int = 0
    var person2Owes: Int = 0
    var person3Owes: Int = 0
    var person4Owes: Int = 0
    var person5Owes: Int = 0
    
    init(obj: NSManagedObject) {
        self.createdDatatime = obj.value(forKey: "createdDate") as? String ?? ""
        self.id = obj.value(forKey: "id") as? Int ?? 0
        self.person1Owes = obj.value(forKey: "person1Owes") as? Int ?? 0
        self.person2Owes = obj.value(forKey: "person2Owes") as? Int ?? 0
        self.person3Owes = obj.value(forKey: "person3Owes") as? Int ?? 0
        self.person4Owes = obj.value(forKey: "person4Owes") as? Int ?? 0
        self.person5Owes = obj.value(forKey: "person5Owes") as? Int ?? 0
    }
    
    init() {}
}

func saveTransactionData(list: [Transaction]){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let transEntity = NSEntityDescription.entity(forEntityName: "TransactionTable", in: managedContext)!
    
    for obj in list{
        let tranObj = NSManagedObject(entity: transEntity, insertInto: managedContext)
        tranObj.setValue(obj.id, forKey: "id")
        tranObj.setValue(obj.createdDatatime, forKey: "createdDate")
        tranObj.setValue(obj.person1Owes, forKey: "person1Owes")
        tranObj.setValue(obj.person2Owes, forKey: "person2Owes")
        tranObj.setValue(obj.person3Owes, forKey: "person3Owes")
        tranObj.setValue(obj.person4Owes, forKey: "person4Owes")
        tranObj.setValue(obj.person5Owes, forKey: "person5Owes")
    }
    
    do{
        try managedContext.save()
    }catch let error as NSError{
        print("Could not save \(error)")
    }
    
}

func getTransData() -> [Transaction]{
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
    
    var result = [Transaction]()
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionTable")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    do{
        let fetchResult = try managedContext.fetch(fetchRequest)
        for data in fetchResult as! [NSManagedObject]{
            result.append(Transaction(obj: data))
        }
        
    }catch{
        print("Could not fetch data \(error)")
    }
    
    return result
}

func clearTransactionData(){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionTable")
    
    do{
        let results = try managedContext.fetch(fetchRequest)
        
        for obj in results as! [NSManagedObject]{
            managedContext.delete(obj)
        }
        
        do{
            try managedContext.save()
        }catch{
            print("Could't delete the objext")
        }
        
    }catch{
        print("Could't clear the Table.")
    }
}
