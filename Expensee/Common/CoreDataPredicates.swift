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
    
    static var currentMonth : NSPredicate
    {
        get
        {
            let startDate = Date().startOfMonth()
            let endDate = Date().endOfMonth()
            let  predicate = NSPredicate(format: "createdDate > %@ AND createdDate <= %@", startDate! as CVarArg, endDate! as CVarArg)
            return predicate
        }
    }
   
}


extension Date{

    func startOfMonth() -> Date? {

        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year,.month], from: self)
        let startOfMonth = calendar.date(from: currentDateComponents)

        return startOfMonth
    }

    func dateByAddingMonths(monthsToAdd: Int) -> Date? {

        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd

        return calendar.date(byAdding: months, to: self)//.dateByAddingComponents(months, toDate: self, options: [])
    }

    func endOfMonth() -> Date? {

        let calendar = Calendar.current
        if let plusOneMonthDate = dateByAddingMonths(monthsToAdd: 1) {
            let plusOneMonthDateComponents = calendar.dateComponents([.year,.month], from: plusOneMonthDate)

            let endOfMonth = calendar.date(from:plusOneMonthDateComponents)
            return endOfMonth
        }

        return nil
    }
}
