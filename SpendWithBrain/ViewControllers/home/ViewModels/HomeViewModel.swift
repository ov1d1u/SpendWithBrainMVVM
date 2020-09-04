//
//  HomeViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 02/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Charts

protocol RefreshViewModelDelegate {
    func refreshUI()
}
struct HomeModel{
    var currentBalance : String = ""
    var todayExpense : String = ""
    var weekExpense : String = ""
    var monthExpense : String = ""
    var dataSetChart : BarChartData = BarChartData()
    var xValueChart : [String] = []
}
class HomeViewModel {
    
    var user = User(password: "", name: "")
    var model : HomeModel?
    var delegate : RefreshViewModelDelegate?
    
    
    
    
    func initializeViewModelNotifi(){
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserData(_:)), name: Notification.Name(rawValue: "refreshUserData"), object: nil)
    }
    
    func initializeUser(user : User){
        self.user = user
        setModel()
        delegate?.refreshUI()
    }
    
    @objc func refreshUserData(_ notification: Notification){
        setModel()
        delegate?.refreshUI()
    }
    
    func setModel(){
        model = HomeModel(currentBalance:String(user.sold.rounded(toPlaces: 2)),
                          todayExpense: String(self.getExpenses(for: 0,with: user).rounded(toPlaces: 2)),
                          weekExpense: String(self.getExpenses(for: 7,with: user).rounded(toPlaces: 2)),
                          monthExpense: String(self.getExpenses(for: 30,with: user).rounded(toPlaces: 2)),
                          dataSetChart: self.getDataSetChart(with: user),
                          xValueChart: self.getArrayMonth())
    }
    
    func isNewUser() -> Bool{
        return user.expenses.count == 0
    }
    
    private func getExpenses(for days: Int,with userDetails: User)-> Float{
        let userExpenses = userDetails.expenses
        var amountExp : Float = 0.0
        let calendar = Calendar.current
        let today = Date()
        if days == 0 {
            for exp in userExpenses{
                if calendar.isDateInToday(exp.date){
                    if exp.category == CategoryEnum.Income{
                        amountExp += exp.amount
                    }else{
                        amountExp -= exp.amount
                    }
                }
            }
            return amountExp
        }
        for exp in userExpenses{
            if exp.date >= calendar.date(byAdding: Calendar.Component.day, value: -days, to: today)!{
                print(calendar.date(byAdding: Calendar.Component.day, value: -days, to: today)!)
                if exp.category == CategoryEnum.Income{
                    amountExp += exp.amount
                }else{
                    amountExp -= exp.amount
                }
            }
        }
        return amountExp
    }
    
    private func getDataSetChart(with userDetails: User) -> BarChartData{
            var arrayOfEntryPositive = [BarChartDataEntry]()
            var arrayOfEntryNegative = [BarChartDataEntry]()
            let currentSpends = getNormalizeArrayOfSpend(with: userDetails)
            for index in currentSpends.indices{
                if(currentSpends[index]>=0){
                    arrayOfEntryPositive.append(BarChartDataEntry(x: Double(index), y: currentSpends[index]))
                }else{
                    arrayOfEntryNegative.append(BarChartDataEntry(x: Double(index), y: currentSpends[index]))
                }
            }
            let chartDataSetPos = BarChartDataSet(values: arrayOfEntryPositive, label: "Positive balance")
            let chartDataSetNeg = BarChartDataSet(values: arrayOfEntryNegative, label: "Negative balance")
            chartDataSetPos.setColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
            chartDataSetNeg.setColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            return BarChartData(dataSets: [chartDataSetPos,chartDataSetNeg])
    }
    
    private func getArrayMonth() -> [String]{
        let Months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        let today = Date()
        let monthComp = Calendar.current.component(.month, from: today)
        var currArray = [String]()
        for mon in stride(from: monthComp, through: 1, by: -1){
            currArray.append(Months[mon-1])
        }
        for mon in monthComp+1...12{
            currArray.append(Months[mon-1])
        }
        currArray.reverse()
        return currArray
    }
    
    private func getNormalizeArrayOfSpend(with userDetails: User) -> [Double]{
        var monthSpends = [Double](repeating: 0, count: 12)
        
        let today = Date()
        for index in userDetails.expenses.indices{
            if userDetails.expenses[index].date >= Calendar.current.date(byAdding: Calendar.Component.day, value: -365, to: today)!{
                let monthComp = Calendar.current.component(.month, from: userDetails.expenses[index].date)
                if userDetails.expenses[index].category == CategoryEnum.Income{
                    monthSpends[monthComp-1] += Double(userDetails.expenses[index].amount)
                }else{
                    monthSpends[monthComp-1] -= Double(userDetails.expenses[index].amount)
                }
            }
        }
        
        var currSpends = [Double]()
        let monthComp = Calendar.current.component(.month, from: today)
        for mon in stride(from: monthComp, through: 1, by: -1){
            currSpends.append(monthSpends[mon-1])
        }
        for mon in monthComp+1...12{
            currSpends.append(monthSpends[mon-1])
        }
        currSpends.reverse()
        return currSpends
    }
}

extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
