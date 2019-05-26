//
//  User.swift
//  GaanaChallenge
//
//  Created by Akshay Kataria on 26/05/19.
//  Copyright © 2019 Akshay Kataria. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class User: Copying {
    required init(original: User) {
        id = original.id
        name = original.name
        dueAmountPerTransaction = original.dueAmountPerTransaction
        masterDueAmountPerTransactionWithRespectToA = original.masterDueAmountPerTransactionWithRespectToA
        overallMasterDueAmountWithRespectToA = original.overallMasterDueAmountWithRespectToA
    }
    
    var id: Int = 0
    var name: String = ""
    var dueAmountPerTransaction: Int = 0
    var paidAmountPerTransaction: Int = 0
    var masterDueAmountPerTransactionWithRespectToA: Int = 0
    var overallMasterDueAmountWithRespectToA: Int = 0
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    init(obj: NSManagedObject) {
        self.name = obj.value(forKey: "name") as? String ?? ""
        self.id = obj.value(forKey: "id") as? Int ?? 0
        self.dueAmountPerTransaction = obj.value(forKey: "dueAmount") as? Int ?? 0
        self.paidAmountPerTransaction = obj.value(forKey: "paidAmount") as? Int ?? 0
        self.masterDueAmountPerTransactionWithRespectToA = obj.value(forKey: "masterDueAmountWrtA") as? Int ?? 0
        self.overallMasterDueAmountWithRespectToA = obj.value(forKey: "overallDueAmountWrtA") as? Int ?? 0
        
    }
}

func saveUserData(list: [User]){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let userEntity = NSEntityDescription.entity(forEntityName: "UserTable", in: managedContext)!
    
    for obj in list{
        let userObj = NSManagedObject(entity: userEntity, insertInto: managedContext)
        userObj.setValue(obj.id, forKey: "id")
        userObj.setValue(obj.name, forKey: "name")
        userObj.setValue(obj.dueAmountPerTransaction, forKey: "dueAmount")
        userObj.setValue(obj.paidAmountPerTransaction, forKey: "paidAmount")
        userObj.setValue(obj.masterDueAmountPerTransactionWithRespectToA, forKey: "masterDueAmountWrtA")
        userObj.setValue(obj.overallMasterDueAmountWithRespectToA, forKey: "overallDueAmountWrtA")
    }
    
    do{
        try managedContext.save()
    }catch let error as NSError{
        print("Could not save \(error)")
    }
    
}

func getUserData() -> [User]{
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
    
    var result = [User]()
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTable")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    do{
        let fetchResult = try managedContext.fetch(fetchRequest)
        for data in fetchResult as! [NSManagedObject]{
            result.append(User(obj: data))
        }
        
    }catch{
        print("Could not fetch data \(error)")
    }
    
    return result
}

func clearUserData(){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTable")
    
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
