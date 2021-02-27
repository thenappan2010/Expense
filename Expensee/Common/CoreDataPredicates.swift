//
//  CoreDataPredicates.swift
//  Expensee
//
//  Created by temp on 27/02/21.
//

import Foundation


class CoreDataPredicate: NSObject {
    
    
    
    static var transactinDatePredicate :  NSSortDescriptor
    {
        get
        {
            let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
            return sortDescriptor
        }
    }
    
    static var incomePredicate : NSPredicate
    {
        get
        {
            let  predicate  = NSPredicate(format: "%K == %@", "transactionType","\(TransactionType.income)")
            return predicate
        }
    }
    
    static var expensePredicate : NSPredicate
    {
        get
        {
            let  predicate  = NSPredicate(format: "%K == %@", "transactionType","\(TransactionType.expense)")
            return predicate
        }
    }
    
   
}
