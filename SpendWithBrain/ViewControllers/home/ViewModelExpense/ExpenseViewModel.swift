//
//  ExpenseViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 02/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Charts

struct ExpenseViewModel{
    var totalExpense : String = ""
    var pieDataSet : PieChartData = PieChartData()
    var user = User(password: "", name: "")
    var expenses = [Expense]()
    var period = 0
    init(user : User,period : Int){
        self.user = user
        totalExpense = String(getSoldForPeriod(getExpenses(for: period)).rounded(toPlaces: 2))
        pieDataSet = getPieData()
        expenses = getExpenses(for: period)
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
        pieDataSet.colors = usedColors
        //pieDataSet.valueFormatter = formatter as? IValueFormatter
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
            if expenses[i].category == CategoryEnum.Income{
                currSold-=expenses[i].amount
            }else{
                currSold+=expenses[i].amount
            }
        }
        return currSold
    }
}
