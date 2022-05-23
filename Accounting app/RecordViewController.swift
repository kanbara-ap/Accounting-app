//
//  RecordViewController.swift
//  Accounting app
//
//  Created by WEBSYSTEM-MAC31 on 2022/05/19.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var spendTextField: UITextField!
    
    let realm = try! Realm()
    var account = Account()
    
    @IBAction func saveButton(_ sender: Any) {
        if titleTextField.text != nil || categoryTextField.text != nil ||
            spendTextField.text != nil {

            let allAccounts = realm.objects(Account.self)
            if allAccounts.count != 0 {
                account.id = allAccounts.max(ofProperty: "id")! + 1
            }
            try! realm.write{
                self.account.title = titleTextField.text!
                self.account.category = categoryTextField.text!
                self.account.spend = spendTextField.textToInt
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let dateString:String = formatter.string(from: datePicker.date)
                self.account.date = dateString
                self.realm.add(self.account,update: .modified)
            }
        }else{
            print("DEBUG_PRINT: 入力データが不足しています")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
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
