//
//  DisplayTransactionListViewController.swift
//  Expensee
//
//  Created by temp on 25/02/21.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class DisplayTransactionListViewController: UIViewController {

    @IBOutlet weak var incomeLabel: UILabel!
    
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var displayType: UIButton!
    
    @IBOutlet weak var graphBtn: UIButton!
    
    var transactionList : [Transaction] = []
    
    var currentDisplayType : transactionDisplayType = .all
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateTransationList()
        incomeLabel.textColor = UIColor.green
        expenseLabel.textColor = UIColor.red
        
        incomeLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        expenseLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        
        incomeLabel.layer.cornerRadius = 8
        expenseLabel.layer.cornerRadius = 8
        
        incomeLabel.clipsToBounds = true
        expenseLabel.clipsToBounds = true
        
        updateIncomeAndExpenseLabel()
        
        table.register(UINib(nibName: "TransactionDisplayTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionDisplayTableViewCell")
        table.delegate = self
        table.dataSource = self
        
        
//        print("startt   \(Date().startOfMonth())")
//        print("enddd   \(Date().endOfMonth())")
    }
    func updateTransationList()
    {
        transactionList = DatabaseOperation.shared.fetchTransaction(sortBasedOnDate: true,transactiontype: currentDisplayType)
        let predicate = { (element: Transaction) in
            return element.category
        }
        let dic = Dictionary(grouping: transactionList, by: predicate)
        
        for (category,transactions) in dic
        {
            let val = transactions.reduce(0) { $0 + ($1.amount) }
            
            print("category : \(category) ___ val  : \(val) ")
            
        }
         print("dic   \(dic)")
        self.table.reloadData()
    }
    
    
    func uploadFile(name: String, folderID: String, fileURL: URL, mimeType: String,service: GTLRDriveService) {
        
        let file = GTLRDrive_File()
        file.name = name
        file.parents = [folderID]
        
        // Optionally, GTLRUploadParameters can also be created with a Data object.
        let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            // This block is called multiple times during upload and can
            // be used to update a progress indicator visible to the user.
        }
        
        service.executeQuery(query) { (_, result, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            // Successful upload if no error is returned.
        }
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
        
        let monthlyExpense = UIAlertAction(title: "Monthly Expense" , style: .default , handler:{ (UIAlertAction)in
            self.currentDisplayType = .monthExpense
            self.updateTransationList()
        })
        
        let monthlyIncome = UIAlertAction(title: "Monthly Income" , style: .default , handler:{ (UIAlertAction)in
            self.currentDisplayType = .monthIncome
            self.updateTransationList()
        })
        
        let all = UIAlertAction(title: "All" , style: .default , handler:{ (UIAlertAction)in
            self.currentDisplayType = .all
            self.updateTransationList()
        })
        
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel , handler:nil)
        
        alert.addAction(onlyIncome)
        alert.addAction(onlyExpense)
        alert.addAction(monthlyIncome)
        alert.addAction(monthlyExpense)
        alert.addAction(all)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func graphAction(_ sender: UIButton) {
        
        let controller = GraphViewController.load(storyboard: "Main", identifier: "GraphViewController")
        
        let predicate = { (element: Transaction) in
            return element.category
        }
        let dic = Dictionary(grouping: transactionList, by: predicate)
        
        var newDict : [String : Int32] = [:]
        for (category,transactions) in dic.prefix(5)
        {
            let val = transactions.reduce(0) { $0 + ($1.amount) }
            newDict[category!] = val
            print("category : \(String(describing: category)) ___ val  : \(val) ")
            
        }
        
        
//        sortedDict["Others"] = dict.sorted(by: byValue).suffix(from: 5).reduce(0) { $0 + ($1.amount) }
        controller.dict = newDict
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addAction(_ sender: UIButton)
//    {
////        uploadFile(name: "name", folderID: "", fileURL: <#T##URL#>, mimeType: "text/plain", service: <#T##GTLRDriveService#>)
//    }
    {

        let controller = AddTransactionViewController.load(storyboard: "Main", identifier: "AddTransactionViewController")
        controller.modalPresentationStyle  = .fullScreen
        controller.saveCallBack = { (category,amount,type,date,reminderDate) in

            DispatchQueue.main.async {
                if let amnt = Int32(amount)
                {
                    let transaction  = DatabaseOperation.shared.initialiseTransactionTable()
                    transaction.category = category
                    transaction.amount = amnt
                    transaction.transactionType = type
                    transaction.createdDate = date
                    transaction.modifiedDate = date
                    if reminderDate != nil{
                        transaction.reminderDate = reminderDate
                    }
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
        cell?.amount.text =  "₹" + String(transactionList[indexPath.item].amount)
        cell?.categoryName.text = transactionList[indexPath.item].category//"Category name"
        
        if let imageName = category.getImageForCategory(category: transactionList[indexPath.item].category ?? "")
        {
            cell?.categoryImage.image = UIImage(named: imageName)!
        }else
        {
            cell?.categoryImage.image = UIImage(systemName: "megaphone.fill")
        }
        if let createdDate = transactionList[indexPath.item].createdDate
        {
            cell?.dateLabel.text = Utils.shared.convertDateToString(date: createdDate)
        }
       
        if transactionList[indexPath.item].transactionType == TransactionType.income
        {
            cell?.amount.textColor = UIColor.green.withAlphaComponent(0.7)
        }else
        {
            cell?.amount.textColor = UIColor.red.withAlphaComponent(0.7)
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("indexPath   \(indexPath.item)")
        
        
        
            
            let controller = AddTransactionViewController.load(storyboard: "Main", identifier: "AddTransactionViewController")
            controller.modalPresentationStyle  = .fullScreen
            controller.transactionObject = transactionList[indexPath.item]
            controller.saveCallBack = { (category,amount,type,date,reminderDate) in
            
                DispatchQueue.main.async {
                    if let amnt = Int32(amount)
                    {
                        let transaction = self.transactionList[indexPath.item]
                        transaction.category = category
                        transaction.amount = amnt
                        transaction.transactionType = type
                        transaction.createdDate = date
                        transaction.modifiedDate = date
                        if reminderDate != nil{
                            transaction.reminderDate = reminderDate
                        }
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
