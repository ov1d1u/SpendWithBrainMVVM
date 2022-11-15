//
//  HomeViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 02/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Charts
import FirebaseDatabase
import Firebase

struct HomeModel{
    var currentBalance : String = ""
    var todayExpense : String = ""
    var weekExpense : String = ""
    var monthExpense : String = ""
    var dataSetChart : BarChartData = BarChartData()
    var xValueChart : [String] = []
}

class HomeViewModel {
    
    var expenses = [Expense]()
    var model : HomeModel?
    var delegate : RefreshViewModelDelegate?
    var delegateGreeting : ShowGreetingMessage?
    

    func initializeUser(){
        Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/expenses").observe(.value, with: { snp in
            self.expenses.removeAll()
            for (key, expenseAny) in snp.value as? NSDictionary ?? [:] {
                //get date
                guard let expense = expenseAny as? NSDictionary else { continue }
                let addedDateFormatter = DateFormatter()
                addedDateFormatter.dateFormat = "yyyy-MM-d HH:mm:ss Z"
                guard let dateString = expense["date"] as? String else { continue }
                let date = addedDateFormatter.date(from: dateString)!
                //get amount
                let amountNumber = (expense["amount"])! as! NSNumber
                //get category
                let categoryRaw = (expense["category"])! as! String
                let category = CategoryEnum.init(rawValue: categoryRaw)!
                //get details and image
                let details = (expense["details"])! as! String
                let image = (expense["image"])! as! String
                //add to expense array
                self.expenses.append(Expense(key as! String,date, amountNumber.floatValue, category, details, image))
            }
            print(self.expenses)
            self.setModel()
            self.delegate?.refreshUI()
            if self.expenses.count == 0 {
                self.delegateGreeting?.showGreeting()
            }
            CustomNotifications.shared.createNotification(self.expenses.sold)
        })
    }
    
    func setModel(){
        model = HomeModel(currentBalance:String(expenses.sold.rounded(toPlaces: 2)),
                          todayExpense: String(self.getExpenses(for: 0,with: expenses).rounded(toPlaces: 2)),
                          weekExpense: String(self.getExpenses(for: 7,with: expenses).rounded(toPlaces: 2)),
                          monthExpense: String(self.getExpenses(for: 30,with: expenses).rounded(toPlaces: 2)),
                          dataSetChart: self.getDataSetChart(with: expenses),
                          xValueChart: self.getArrayMonth())
    }
    
    private func getExpenses(for days: Int,with userDetails: [Expense])-> Float{
        var amountExp : Float = 0.0
        let calendar = Calendar.current
        let today = Date()
        if days == 0 {
            for exp in userDetails{
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
        for exp in userDetails{
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
    
    private func getDataSetChart(with userDetails: [Expense]) -> BarChartData{
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
        
        let chartDataSetPos = BarChartDataSet(entries: arrayOfEntryPositive, label: "Positive balance")
        let chartDataSetNeg = BarChartDataSet(entries: arrayOfEntryNegative, label: "Negative balance")
        chartDataSetPos.setColor(#colorLiteral(red: Float(0.4666666687), green: Float(0.7647058964), blue: Float(0.2666666806), alpha: Float(0)))
        chartDataSetNeg.setColor(#colorLiteral(red: Float(0.7450980544), green: Float(0.1568627506), blue: Float(0.07450980693), alpha: Float(1)))
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
    
    private func getNormalizeArrayOfSpend(with userDetails: [Expense]) -> [Double]{
        var monthSpends = [Double](repeating: 0, count: 12)
        let today = Date()
        
        for index in userDetails.indices{
            if userDetails[index].date >= Calendar.current.date(byAdding: Calendar.Component.day, value: -365, to: today)!{
                let monthComp = Calendar.current.component(.month, from: userDetails[index].date)
                if userDetails[index].category == CategoryEnum.Income{
                    monthSpends[monthComp-1] += Double(userDetails[index].amount)
                }else{
                    monthSpends[monthComp-1] -= Double(userDetails[index].amount)
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

extension Array where Element == Expense{
    var sold : Float {
        var calcSold : Float = 0
        
        for index in self.indices{
            if self[index].category == CategoryEnum.Income{
                calcSold += self[index].amount
            }else{
                calcSold -= self[index].amount
            }
        }
        
        return calcSold
    }
}
