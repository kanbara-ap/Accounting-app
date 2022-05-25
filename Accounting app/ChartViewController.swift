import UIKit
import Charts
import RealmSwift
class ChartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var categoryTable: UITableView!
    
    var year: Int = 0
    var month: Int = 0
    let categoryData: [String] = ["固定費","食費","日用品","被服・美容費","娯楽費","交通費","医療費","交際費","その他"]


    
    @IBAction func nextMonthButton(_ sender: Any) {
        month += 1
        if month > 12{
            month = 1
            year += 1
        }
        createPieChart()
    }
    
    @IBAction func backMonthButton(_ sender: Any) {
        month -= 1
        if month < 1 {
            month = 12
            year -= 1
        }
        createPieChart()
    }
    @IBOutlet weak var pieChartsView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let current = Calendar.current
        year = current.component(.year, from: Date())
        month = current.component(.month, from: Date())
        createPieChart()
        self.categoryTable.delegate = self
        self.categoryTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createPieChart()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTable.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as? categoryTableViewCell else {
            fatalError("Dequeue failed: AnimalTableViewCell.")
        }

        
        let monthString = String(year) + "-" + String(format: "%02d",month)
        let accountArray =  try! Realm().objects(Account.self).sorted(byKeyPath: "date", ascending: true).filter("date CONTAINS %@",monthString).filter("category == %@",categoryData[indexPath.row])
        let sum: Int = accountArray.sum(ofProperty: "spend")
        
        cell.cellTitle.text = categoryData[indexPath.row]
        cell.spend.text = String(sum)

        return cell
    }
    
    func createPieChart(){
        // 円グラフの中心に表示するタイトル
        self.pieChartsView.centerText = String(year) + "年" + String(month) + "月"
        
        // グラフに表示するデータのタイトルと値
        var dataEntries:[ChartDataEntry] = []
        let monthString = String(year) + "-" + String(format: "%02d",month)


        for category in categoryData {
            let accountArray =  try! Realm().objects(Account.self).sorted(byKeyPath: "date", ascending: true).filter("date CONTAINS %@",monthString).filter("category == %@",category)
            dataEntries += [PieChartDataEntry(value: accountArray.sum(ofProperty: "spend"), label: category)]
        }
        
//            PieChartDataEntry(value: 40, label: "A")

        
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")

        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black

        
        
        
        
        let C255 = Double(256)
        let C127 = Double(127)
        let C191 = Double(191)
 
        let color1 = UIColor(red: CGFloat(C255/255), green: CGFloat(C127/255), blue: CGFloat(C127/255), alpha: 1)
        let color2 = UIColor(red: CGFloat(C255/255), green: CGFloat(C127/255), blue: CGFloat(C191/255), alpha: 1)
        let color3 = UIColor(red: CGFloat(C255/255), green: CGFloat(C127/255), blue: CGFloat(C255/255), alpha: 1)
        let color4 = UIColor(red: CGFloat(C191/255), green: CGFloat(C127/255), blue: CGFloat(C255/255), alpha: 1)
        let color5 = UIColor(red: CGFloat(C127/255), green: CGFloat(C127/255), blue: CGFloat(C255/255), alpha: 1)
        let color6 = UIColor(red: CGFloat(C255/255), green: CGFloat(C127/255), blue: CGFloat(C255/255), alpha: 1)
        let color7 = UIColor(red: CGFloat(C127/255), green: CGFloat(C191/255), blue: CGFloat(C255/255), alpha: 1)
        let color8 = UIColor(red: CGFloat(C127/255), green: CGFloat(C255/255), blue: CGFloat(C255/255), alpha: 1)
        let color9 = UIColor(red: CGFloat(C127/255), green: CGFloat(C255/255), blue: CGFloat(C191/255), alpha: 1)
        
        let colors: [UIColor] = [color1,color2,color3,color4,color5,color6,color7,color8,color9]
        
        
        dataSet.colors = colors
        
        self.pieChartsView.data = PieChartData(dataSet: dataSet)

        
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        self.pieChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.pieChartsView.usePercentValuesEnabled = true
        
        view.addSubview(self.pieChartsView)
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

