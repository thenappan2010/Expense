//
//  AddTransactionViewController.swift
//  Expensee
//
//  Created by temp on 26/02/21.
//

import UIKit



class AddTransactionViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var dateBtn: UIButton!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    var selectedDate : Date?
    var saveCallBack : ((String,String,String,Date)->Void)?
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
            
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        validateSaveButton()

    }
    @IBAction func categoryAction(_ sender: Any) {
        
        let controller = CategoryListViewController.load(storyboard: "Main", identifier: "CategoryListViewController")
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
        
        saveCallBack?(categoryButton.titleLabel?.text ?? "",self.amountTF.text ?? "",(segment.selectedSegmentIndex == 1 ? TransactionType.income  :TransactionType.expense),selectedDate ?? Date())
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateSaveButton()
    {
        let categoryCondition = category.getAllCategorys().contains(categoryButton.titleLabel?.text ?? "")
        let amountCondition = amountTF.text?.isEmpty == false && (Int32(amountTF.text!) != nil)
        
        saveBtn.isEnabled = (categoryCondition && amountCondition)
        
        
    }
    
}
