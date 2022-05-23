//
//  CalendarViewController.swift
//  Accounting app
//
//  Created by WEBSYSTEM-MAC31 on 2022/05/19.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let account = accountArray[indexPath.row]
        cell.textLabel?.text = account.title + " " + account.category
        cell.detailTextLabel?.text = ":" + String(account.spend)
        return cell
    }
    
    let realm = try! Realm()
    
    var accountArray = try! Realm().objects(Account.self).sorted(byKeyPath: "date", ascending: true)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var totalAccount: UILabel!
    var sum :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        let year = Calendar.current.component(.year, from: currentPageDate)
        let monthString = String(year) + "-" + String(format: "%02d",month)
        accountArray =  try! Realm().objects(Account.self).sorted(byKeyPath: "date", ascending: true).filter("date CONTAINS %@",monthString)
        print(monthString)

        
        self.calendar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        sum  = accountArray.sum(ofProperty: "spend")
        totalAccount.text = "合計　：　" + String(sum) + "円"
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        let year = Calendar.current.component(.year, from: currentPageDate)
        let monthString = String(year) + "-" + String(format: "%02d",month)
        accountArray =  try! Realm().objects(Account.self).sorted(byKeyPath: "date", ascending: true).filter("date CONTAINS %@",monthString)
        print(monthString)
        tableView.reloadData()
        sum  = accountArray.sum(ofProperty: "spend")
        totalAccount.text = "合計　：　" + String(sum) + "円"
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString:String = formatter.string(from: date)
        accountArray =  try! Realm().objects(Account.self).sorted(byKeyPath: "date", ascending: true).filter("date = %@",dateString)
        tableView.reloadData()
        sum  = accountArray.sum(ofProperty: "spend")
        totalAccount.text = "合計　：　" + String(sum)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
            return .delete
        
    }


        // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete{
    
            let account = self.accountArray[indexPath.row]
            
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(account.id)])

            try! realm.write{
                realm.delete(self.accountArray[indexPath.row])
                tableView.deleteRows(at: [indexPath],with: .fade)
            }
            
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        }
            
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
