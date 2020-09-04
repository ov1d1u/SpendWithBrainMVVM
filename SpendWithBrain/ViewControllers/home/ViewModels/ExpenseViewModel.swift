//
//  ExpenseViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 02/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Charts


struct ExpenseDataModel{
    var totalExpense : String
    var pieDataSet : PieChartData
    var period : Int
    var expenses : [Expense]
}
class ExpenseViewModel{
    var user = User(password: "", name: "")
    var model : ExpenseDataModel?
    var delegate : RefreshViewModelDelegate?
    
    func initUserAndPeriod(user : User,forPeriod period : Int){
        self.user = user
        setModel(forPeriod: period)
    }
    
    func initNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserData(_:)), name: Notification.Name(rawValue: "refreshExpenseScreen"), object: nil)
    }
    
    func setModel(forPeriod period: Int){
        model = ExpenseDataModel(totalExpense: String(getSoldForPeriod(getExpenses(for: period)).rounded(toPlaces: 2)),
                                 pieDataSet: getPieData(),
                                 period: period,
                                 expenses : getExpenses(for: period))
        delegate?.refreshUI()
    }
    
    func updateUserInfo(){
        user = LocalDataBase.getUserInfo()!
    }
    
    
    @objc func refreshUserData(_ notification: Notification){
        updateUserInfo()
        switch model?.period {
        case 7: print("Selected week info")
        setModel(forPeriod: 7)
        case 30: print("Selected month info")
        setModel(forPeriod: 30)
        case 365: print("Selected year info")
        setModel(forPeriod: 365)
        default:
            break
        }
    }
    
    private func getSoldForPeriod(_ expenses : [Expense]) -> Float{
        var expense : Float = 0.0
        for exp in expenses{
            exp.category == .Income ? (expense+=exp.amount) : (expense-=exp.amount)
        }
        return expense
    }
    
    private func getExpenses(for days: Int)-> [Expense]{
        let userExpenses = user.expenses
        var expensesForPeriod = [Expense]()
        let calendar = Calendar.current
        let today = Date()
        for exp in userExpenses{
            if exp.date >= calendar.date(byAdding: Calendar.Component.day, value: -days, to: today)!{
                expensesForPeriod.append(exp)
            }
        }
        expensesForPeriod.sort(by: {$0.date > $1.date})
        return expensesForPeriod
    }
    
    private func getPieData() ->PieChartData{
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
        
        let pieDataSet = PieChartDataSet(values: dataEntries, label: "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieDataSet.valueFormatter = formatter as? IValueFormatter
        pieDataSet.valueTextColor = .black
        pieDataSet.colors = usedColors
        let pieChartData = PieChartData(dataSet: pieDataSet)
        return pieChartData
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
    
    func getSoldForThisExpense(at index: Int)-> Float{
        var currSold = user.sold
        if index == 0 {
            return currSold
        }
        for i in 0..<index{
            if model!.expenses[i].category == CategoryEnum.Income{
                currSold-=model!.expenses[i].amount
            }else{
                currSold+=model!.expenses[i].amount
            }
        }
        return currSold
    }
}
