//
//  RecordViewController.swift
//  Accounting app
//
//  Created by WEBSYSTEM-MAC31 on 2022/05/19.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var spendTextField: UITextField!
    
    let realm = try! Realm()
    var account = Account()
    var pickerView = UIPickerView()
    var data: [String] = ["固定費","食費","日用品","被服・美容費","娯楽費","交通費","医療費","交際費","その他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        categoryTextField.delegate = self
        createPickerView()

        // Do any additional setup after loading the view.
    }
    
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
   
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = data[row]
    }
    func createPickerView(){
        pickerView.delegate = self
        categoryTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButtonItem],animated: true)
        categoryTextField.inputAccessoryView = toolbar
    }
    @objc func donePicker(){
        categoryTextField.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        categoryTextField.endEditing(true)
    }
    
    //category選択欄にキーボードから入力不可にする
    func textField(_ TextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        return false
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
