//
//  MainTabBarViewController.swift
//  Expensee
//
//  Created by temp on 03/03/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let Transactions = DisplayTransactionListViewController.load(storyboard: "Main", identifier: "DisplayTransactionListViewController")
        let item1 = UITabBarItem()
        item1.title = "Transactions"
        Transactions.tabBarItem = item1
        
        let Dashboard = GraphViewController.load(storyboard: "Main", identifier: "GraphViewController")
        let item2 = UITabBarItem()
        item2.title = "Dashboard"
        Dashboard.tabBarItem = item2
        
        
        let Add = AddTransactionViewController.load(storyboard: "Main", identifier: "AddTransactionViewController")
        let item3 = UITabBarItem()
        item3.title = "Add"
        Add.tabBarItem = item3
        
       
        

        self.viewControllers = [Dashboard,Add,Transactions]
        self.selectedViewController = Transactions
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
