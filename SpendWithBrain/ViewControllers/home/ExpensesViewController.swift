//
//  ExpensesViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 21/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import Charts
class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var chart: PieChartView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    private var userAcutalInfo : User?
    private var expensesForSelectedPeriod = [Expense]()
    private var infoView : ShowInfoViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserData(_:)), name: Notification.Name(rawValue: "refreshExpenseScreen"), object: nil)
        userAcutalInfo = LocalDataBase.getUserInfo()
        fillWithStartData(7)
        customize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "My Expenses"
    }
    
    @objc func refreshUserData(_ notification: Notification){
        userAcutalInfo = LocalDataBase.getUserInfo()
        switch segmentControll.selectedSegmentIndex {
        case 0: print("Selected week info")
        fillWithStartData(7)
        case 1: print("Selected month info")
        fillWithStartData(30)
        case 2: print("Selected year info")
        fillWithStartData(365)
        default:
            break
        }
        fillPie()
        print(expensesForSelectedPeriod)
    }
    
    private func fillWithStartData(_ days : Int){
        expensesForSelectedPeriod = getExpenses(for: days)
        expensesForSelectedPeriod.sort(by: {$0.date > $1.date})
        table.reloadData()
        amountLabel.text = String(getExpenseForPeriod().rounded(toPlaces: 2))
        fillPie()
    }
    
    private func getExpenseForPeriod() -> Float{
        var expense : Float = 0.0
        for exp in expensesForSelectedPeriod{
            exp.category == .Income ? (expense+=exp.amount) : (expense-=exp.amount)
        }
        return expense
    }
    
    private func customize(){
        segmentControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        segmentControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
        chart.legend.enabled = false
    }
    private func fillPie(){
        let periods = ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4"]
        let colors = [#colorLiteral(red: 0.6144174286, green: 1, blue: 0.5886259926, alpha: 1),#colorLiteral(red: 1, green: 0.9858698406, blue: 0.440488844, alpha: 1),#colorLiteral(red: 0.3863234386, green: 0.9176713198, blue: 0.1130531465, alpha: 1),#colorLiteral(red: 0.5958678644, green: 0.7873531485, blue: 0.9738657995, alpha: 1)]
        var usedColors : [UIColor] = []
        let percentPerPeriod = getPercentsForExpenses()
        var dataEntries = [ChartDataEntry]()
        for (index, value) in percentPerPeriod.enumerated(){
            if value > 0{
                let entry = PieChartDataEntry()
                entry.value = value
                entry.label = periods[index]
                dataEntries.append(entry)
                usedColors.append(colors[index])
            }
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        let pieDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieDataSet.colors = usedColors
        pieDataSet.valueFormatter = formatter as? IValueFormatter
        let pieChartData = PieChartData(dataSet: pieDataSet)
        chart.data = pieChartData
        chart.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chart.data?.setValueTextColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        let pieChartAttribute = [ NSAttributedString.Key.font: UIFont(name: "Arial", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 0.462, green: 0.838, blue: 1.000, alpha: 1) ]
        let pieChartAttrString = NSAttributedString(string: "Quarterly Revenue", attributes: pieChartAttribute)
        chart.centerAttributedText = pieChartAttrString
    }
    private func getPercentsForExpenses() -> [Double]{
        var percents : [Double] = [0.0,0.0,0.0,0.0]
        var expensePerPeriod :[Double] = [0.0,0.0,0.0,0.0]
        var allExpense : Double = 0.0
        for exp in getExpenses(for: 365){
            if(exp.category == .Income){
                let month = Calendar.current.component(.month, from: exp.date)
                switch month {
                case 1...3 : expensePerPeriod[0] += Double(exp.amount)
                case 4...6 : expensePerPeriod[1] += Double(exp.amount)
                case 7...9 : expensePerPeriod[2] += Double(exp.amount)
                case 10...12: expensePerPeriod[3] += Double(exp.amount)
                default:
                    break
                }
                allExpense += Double(exp.amount)
            }
        }
        for i in 0...3{
            if expensePerPeriod[i] != 0.0{
                percents[i] = (Double(expensePerPeriod[i]) / Double(allExpense))*100
            }
        }
        return percents
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        if userAcutalInfo != nil{
            switch sender.selectedSegmentIndex {
            case 0: print("Selected week info")
                fillWithStartData(7)
            case 1: print("Selected month info")
                fillWithStartData(30)
            case 2: print("Selected year info")
                fillWithStartData(365)
            default:
                break
            }
            print(expensesForSelectedPeriod)
            
        }
    }
    
    private func getExpenses(for days: Int)-> [Expense]{
        let userExpenses = userAcutalInfo!.expenses
        var expensesForPeriod = [Expense]()
        let calendar = Calendar.current
        let today = Date()
        for exp in userExpenses{
            if exp.date >= calendar.date(byAdding: Calendar.Component.day, value: -days, to: today)!{
                expensesForPeriod.append(exp)
            }
        }
        return expensesForPeriod
    }
    
    private func getSoldForThisExpense(at index: Int)-> Float{
        var currSold = userAcutalInfo!.sold
        if index == 0 {
            return currSold
        }
        for i in 0..<index{
            if expensesForSelectedPeriod[i].category == CategoryEnum.Income{
                currSold-=expensesForSelectedPeriod[i].amount
            }else{
                currSold+=expensesForSelectedPeriod[i].amount
            }
        }
        return currSold
    }
    
    private func getCategoryImage(for category: CategoryEnum)->UIImage{
        switch category {
        case .Income: return #imageLiteral(resourceName: "money_icon.png")
        case .Food: return #imageLiteral(resourceName: "food_icon")
        case .Car: return #imageLiteral(resourceName: "car_icon")
        case .Clothes: return #imageLiteral(resourceName: "clothes")
        case .Savings: return #imageLiteral(resourceName: "savings_icon")
        case .Health: return #imageLiteral(resourceName: "health_icon")
        case .Beauty: return #imageLiteral(resourceName: "makeup_icon")
        case .Travel: return #imageLiteral(resourceName: "world")
        }
    }
    
    @objc func selectOneExpense(_ sender:UITapGestureRecognizer){
        let showDialog = ShowInfo()
        let showVC = showDialog.alert()
        let cell = sender.view as! CustomTableViewCell
        showVC.setData(cell)
        present(showVC, animated: true)
    }
}
extension ExpensesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesForSelectedPeriod.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "custom") as! CustomTableViewCell
        let thisExpense = expensesForSelectedPeriod[indexPath.row]
        cell.incExp.text = thisExpense.category == CategoryEnum.Income ? "Income" : "Expense"
        cell.imgCat.image = getCategoryImage(for: thisExpense.category)
        cell.category.text = String(thisExpense.category.rawValue)
        //set data
        if Calendar.current.isDateInToday(thisExpense.date){
            cell.dateOfExp.text = "Today"
        }else if Calendar.current.isDateInYesterday(thisExpense.date){
            cell.dateOfExp.text = "Yesterday"
        }else {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "E d MMM"
            cell.dateOfExp.text = String(dateFormat.string(from: thisExpense.date))
        }
        let amount = thisExpense.amount
        if thisExpense.category != CategoryEnum.Income {
            cell.amount.text = "-\(amount)"
            cell.amount.textColor = #colorLiteral(red: 0.9921568627, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
        } else{
            cell.amount.text = "+\(amount)"
            cell.amount.textColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
        }
        let currSold = getSoldForThisExpense(at: indexPath.row)
        if currSold<0{
            cell.soldAfterExp.text = "-\(currSold)"
            cell.soldAfterExp.textColor = #colorLiteral(red: 0.9921568627, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
        } else{
            cell.soldAfterExp.text = String(currSold)
        }
        cell.details = thisExpense.details
        cell.imagePath = thisExpense.image
        cell.date = thisExpense.date
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(selectOneExpense(_:)))
        cell.addGestureRecognizer(tapGest)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
