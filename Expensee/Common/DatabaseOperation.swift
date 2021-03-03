//
//  DatabaseOperation.swift
//  Expensee
//
//  Created by temp on 25/02/21.
//

import Foundation
import UIKit
import CoreData


class DatabaseOperation: NSObject {
    
    static let shared = DatabaseOperation()
    
    @objc class func context() -> NSManagedObjectContext
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func initialiseTransactionTable() -> Transaction
    {
        let transaction = NSEntityDescription.entity(forEntityName: "Transaction", in: DatabaseOperation.context())
        let docData = Transaction.init(entity: transaction!, insertInto:DatabaseOperation.context())
        return docData
    }
    
    func save()->Bool
    {
        let context = DatabaseOperation.context()
            if context.hasChanges {
                do {
                    try context.save()
                    return true
                } catch _ {
                    return false
                }
            }

        return false
    }
    
    func fetchTransaction(sortBasedOnDate: Bool? = false,transactiontype : transactionDisplayType) -> [Transaction]
    {
        let context = DatabaseOperation.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
        
        if transactiontype == .all
        {
            
        }else if transactiontype == .onlyExpense
        {
            fetchRequest.predicate =  CoreDataPredicate.expensePredicate
        }else if transactiontype == .onlyIncome
        {
            fetchRequest.predicate =  CoreDataPredicate.incomePredicate
        }else if transactiontype == .monthIncome
        {
            let combined = NSCompoundPredicate(type: .and, subpredicates: [CoreDataPredicate.incomePredicate,  CoreDataPredicate.currentMonth])
            fetchRequest.predicate =  combined
        }else if transactiontype == .monthExpense
        {
            let combined = NSCompoundPredicate(type: .and, subpredicates: [CoreDataPredicate.expensePredicate,  CoreDataPredicate.currentMonth])
            fetchRequest.predicate =  combined
        }
        
                
        if sortBasedOnDate ==  true
        {
            fetchRequest.sortDescriptors  = [CoreDataPredicate.transactinDatePredicate]
        }
        
        do{
            if let alltransactions = try context.fetch(fetchRequest) as? [Transaction]
            {
                return alltransactions
            }
        }catch{
            
        }
        
        return []
    }
    
//    func fetchAllIncome(sortBasedOnDate: Bool? = false) -> [Transaction]
//    {
//        let context = DatabaseOperation.context()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//
//
//        if sortBasedOnDate ==  true
//        {
//            fetchRequest.sortDescriptors  = [CoreDataPredicate.transactinDatePredicate]
//        }
//        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
//
//        do{
//            if let alltransactions = try context.fetch(fetchRequest) as? [Transaction]
//            {
//                return alltransactions
//            }
//        }catch{
//
//        }
//
//        return []
//    }
    
//    func fetchAllExpense(sortBasedOnDate: Bool? = false) -> [Transaction]
//    {
//        let context = DatabaseOperation.context()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        let  predicate  = NSPredicate(format: "%K == %@", "transactionType","\(TransactionType.expense)")
//
//        fetchRequest.predicate =  predicate
//        if sortBasedOnDate ==  true
//        {
//            fetchRequest.sortDescriptors  = [CoreDataPredicate.transactinDatePredicate]
//        }
//        
//        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
//        
//        do{
//            if let alltransactions = try context.fetch(fetchRequest) as? [Transaction]
//            {
//                return alltransactions
//            }
//        }catch{
//            
//        }
//        
//        return []
//    }
//    
    func fetchAllCategory() -> [Category]
    {
        let context = DatabaseOperation.context()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Category", in: context)
        
        do{
            if let alltransactions = try context.fetch(fetchRequest) as? [Category]
            {
                return alltransactions
            }
        }catch{
            
        }
        
        return []
    }
}
