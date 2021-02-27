//
//  DisplayTransactionListViewController.swift
//  Expensee
//
//  Created by temp on 25/02/21.
//

import UIKit

class DisplayTransactionListViewController: UIViewController {

    @IBOutlet weak var incomeLabel: UILabel!
    
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var displayType: UIButton!
    
    
    var transactionList : [Transaction] = []
    
    var currentDisplayType : transactionDisplayType = .all
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateTransationList()
        incomeLabel.textColor = UIColor.green
        expenseLabel.textColor = UIColor.red
        updateIncomeAndExpenseLabel()
        
        table.register(UINib(nibName: "TransactionDisplayTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionDisplayTableViewCell")
        table.delegate = self
        table.dataSource = self
        
    }
    func updateTransationList()
    {
        if currentDisplayType == .all
        {
            transactionList = DatabaseOperation.shared.fetchTransaction(sortBasedOnDate: true,transactiontype: .all)
        }else if currentDisplayType == .onlyIncome
        {
            transactionList = DatabaseOperation.shared.fetchTransaction(sortBasedOnDate: true,transactiontype: .onlyIncome)
        }else if currentDisplayType == .onlyExpense
        {
            transactionList = DatabaseOperation.shared.fetchTransaction(sortBasedOnDate: true,transactiontype: .onlyExpense)
        }
        self.table.reloadData()
        
    }
    
    
    func updateIncomeAndExpenseLabel()
    {
        let totalIncome = DatabaseOperation.shared.fetchTransaction(transactiontype: .onlyIncome).reduce(0) { $0 + ($1.amount) }
        incomeLabel.text = String(totalIncome)
        
        let totalExpense = DatabaseOperation.shared.fetchTransaction(transactiontype: .onlyExpense).reduce(0) { $0 + ($1.amount) }
        expenseLabel.text = String(totalExpense)
    }
    
    @IBAction func displayTypeAction(_ sender: Any) {
        
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let onlyIncome = UIAlertAction(title: "Income" , style: .default , handler:{ (UIAlertAction)in
            self.currentDisplayType = .onlyIncome
            self.updateTransationList()
        })
        
        let onlyExpense = UIAlertAction(title: "Expense" , style: .default , handler:{ (UIAlertAction)in
            self.currentDisplayType = .onlyExpense
            self.updateTransationList()
        })
        
        let all = UIAlertAction(title: "All" , style: .default , handler:{ (UIAlertAction)in
            self.currentDisplayType = .all
            self.updateTransationList()
        })
        
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel , handler:nil)
        
        alert.addAction(onlyIncome)
        alert.addAction(onlyExpense)
        alert.addAction(all)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func addAction(_ sender: UIButton) {
        
        let controller = AddTransactionViewController.load(storyboard: "Main", identifier: "AddTransactionViewController")
        controller.modalPresentationStyle  = .fullScreen
        controller.saveCallBack = { (category,amount,type,date) in
            
            DispatchQueue.main.async {
                if let amnt = Int32(amount)
                {
                    let transaction  = DatabaseOperation.shared.initialiseTransactionTable()
                    transaction.category = category
                    transaction.amount = amnt
                    transaction.transactionType = type
                    transaction.createdDate = date
                    transaction.modifiedDate = date
                }
                _=DatabaseOperation.shared.save()
                self.updateTransationList()
                print("category   \(category)")
                print("amount   \(amount)")
                self.updateIncomeAndExpenseLabel()
            }
           
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    
  
}

extension DisplayTransactionListViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDisplayTableViewCell", for: indexPath) as? TransactionDisplayTableViewCell
        cell?.amount.text = String(transactionList[indexPath.item].amount)
        cell?.categoryName.text = transactionList[indexPath.item].category//"Category name"
        
        if let createdDate = transactionList[indexPath.item].createdDate
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-YYYY HH:mm"
            cell?.dateLabel.text = dateFormatter.string(from: createdDate)
        }
       
        if transactionList[indexPath.item].transactionType == TransactionType.income
        {
            cell?.amount.textColor = UIColor.green
        }else
        {
            cell?.amount.textColor = UIColor.red
        }
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YY, MMM d"
//        cell.detailTextLabel?.text = dateFormatter.string(from: Date())
//        cell.detailTextLabel?.textColor = UIColor.red

        return cell!
    }
    
    
}
