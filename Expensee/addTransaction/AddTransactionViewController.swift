//
//  AddTransactionViewController.swift
//  Expensee
//
//  Created by temp on 26/02/21.
//

import UIKit
import UserNotifications



class AddTransactionViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var dateBtn: UIButton!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var remiderBtn: UIButton!
    
    
    var selectedDate : Date?
    var reminderDate : Date?
    var saveCallBack : ((String,String,String,Date,Date?)->Void)?
    var transactionObject : Transaction?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        preFillValues()
        
        validateSaveButton()
        // Do any additional setup after loading the view.
    }
    
    func preFillValues()
    {
        if let obj = transactionObject
        {
            self.amountTF.text = String(obj.amount)
            self.segment.selectedSegmentIndex = (obj.transactionType == TransactionType.expense ? 0 : 1)
            self.categoryButton.setTitle(obj.category, for: .normal)
            if let createdDate = obj.createdDate
            {
                self.dateBtn.setTitle(Utils.shared.convertDateToString(date: createdDate), for: .normal)
            }
            
            if let reminderDate = obj.reminderDate
            {
                self.remiderBtn.setTitle(Utils.shared.convertDateToString(date: reminderDate), for: .normal)
            }
            
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        validateSaveButton()

    }
    @IBAction func categoryAction(_ sender: Any) {
        
        let controller = CategoryListViewController.load(storyboard: "Main", identifier: "CategoryListViewController")
        controller.selectedCategory = self.categoryButton.titleLabel?.text ?? nil
        controller.categorySelectionCallBack = { (category) in
            self.categoryButton.setTitle(category, for: .normal)
            self.validateSaveButton()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func dateSelection(_ sender: UIButton) {
        
        let controller = DatePickerViewController.load(storyboard: "Main", identifier: "DatePickerViewController")
        controller.dateCallBack = { (date) in
            self.selectedDate = date
           
            self.dateBtn.setTitle(Utils.shared.convertDateToString(date: date), for: .normal)
            
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        if transactionObject == nil && reminderDate != nil
        {
            addReminder(reminderDate: reminderDate!)
        }else if reminderDate != nil
        {
           if transactionObject?.reminderDate !=  reminderDate!
           {
                addReminder(reminderDate: transactionObject?.reminderDate)
           }

        }
        
        saveCallBack?(categoryButton.titleLabel?.text ?? "",self.amountTF.text ?? "",(segment.selectedSegmentIndex == 1 ? TransactionType.income  :TransactionType.expense),selectedDate ?? Date(),reminderDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func addReminder(reminderDate : Date?)
    {
        print("addReminder")
        let content = UNMutableNotificationContent()
        content.title = "Time to add Expense"
        content.sound = .default
        if self.getCurrentCategoryName().isEmpty == false
        {
            content.body = "Your \(self.getCurrentCategoryName()) is about to expire"
        }
        
        
        
        if let date = reminderDate
        {
            let testDate = date//Date().addingTimeInterval(10)
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.minute,.day,.hour,.second], from: testDate), repeats: true)
            let  id = UUID().uuidString
            let request =  UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request) { (error) in
                print("remiinder error \(String(describing: error))")
            }
        }
    }
    
    
    
    @IBAction func reminderAction(_ sender: Any) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
            if success
            {
                
                
            }else{
                
            }
        }
        
        
        let controller = DatePickerViewController.load(storyboard: "Main", identifier: "DatePickerViewController")
        controller.dateCallBack = { (date) in
            self.reminderDate = date
           
            self.remiderBtn.setTitle(Utils.shared.convertDateToString(date: date), for: .normal)
            
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func validateSaveButton()
    {
        let categoryCondition = category.getAllCategorys().contains(categoryButton.titleLabel?.text ?? "")
        let amountCondition = amountTF.text?.isEmpty == false && (Int32(amountTF.text!) != nil)
        
        saveBtn.isEnabled = (categoryCondition && amountCondition)
        
        
    }
    
    
    func getCurrentCategoryName()->String
    {
       if let category = transactionObject?.category
       {
            return category
       }else if categoryButton.titleLabel?.text?.isEmpty == false
       {
            return (categoryButton.titleLabel?.text!)!
       }
        return ""
    }
    
}

extension AddTransactionViewController : UNUserNotificationCenterDelegate

{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if notification.request.trigger is UNCalendarNotificationTrigger || notification.request.trigger is UNTimeIntervalNotificationTrigger {
            
         
        }
        
        completionHandler([.alert, .badge, .sound])
    }
}
