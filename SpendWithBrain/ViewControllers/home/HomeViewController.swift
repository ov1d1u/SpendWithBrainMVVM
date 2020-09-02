//
//  HomeViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 20/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController{

    @IBOutlet weak var currentBalanceViewContainer: UIView!
    @IBOutlet weak var todatExpenseViewContainer: UIView!
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var todayExp: UILabel!
    @IBOutlet weak var weekExp: UILabel!
    @IBOutlet weak var monthExp: UILabel!
    @IBOutlet weak var chartDetails: BarChartView!
    var userDetails = LocalDataBase.getUserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserData(_:)), name: Notification.Name(rawValue: "refreshUserData"), object: nil)
        customize()
        fillWithData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "My Budget"
    }
    
    @objc func refreshUserData(_ notification: Notification){
        fillWithData()
    }
    
    private func fillWithData(){
        //fill labels with user info
        userDetails = LocalDataBase.getUserInfo()
        if(userDetails?.expenses.count==0){
            AlertService.showAlert(style: .alert, title: "Hello, dear user", message: "Now you have no expenses, to start see the Add button at the top right.")
        }
        currentBalanceLbl.text = String(userDetails!.sold.rounded(toPlaces: 2))
        weekExp.text = String(getExpenses(for: 7).rounded(toPlaces: 2))
        monthExp.text = String(getExpenses(for: 30).rounded(toPlaces: 2))
        todayExp.text = String(getExpenses(for: 0).rounded(toPlaces: 2))
        print(userDetails!)
        
        //prepare dataset for chart
        var arrayOfEntryPositive = [BarChartDataEntry]()
        var arrayOfEntryNegative = [BarChartDataEntry]()
        let currentSpends = getNormalizeArrayOfSpend()
        chartDetails.xAxis.valueFormatter = IndexAxisValueFormatter(values: getArrayMonth())
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
        let charData = BarChartData(dataSets: [chartDataSetPos,chartDataSetNeg])
        //fill chart with data
        chartDetails.data = charData
    }
    
    private func customize(){
        //customize design
        currentBalanceViewContainer.layer.cornerRadius = 5
        todatExpenseViewContainer.layer.borderWidth = 1
        todatExpenseViewContainer.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //chart design count of label and position of xvalue
        chartDetails.xAxis.labelPosition = .bothSided
        chartDetails.xAxis.labelCount = 12
        //disable horizontal line for background grid
        chartDetails.leftAxis.drawGridLinesEnabled = false
        chartDetails.rightAxis.drawGridLinesEnabled = false
        //center legeng
        chartDetails.legend.horizontalAlignment = .center
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
    
    private func getNormalizeArrayOfSpend() -> [Double]{
        var monthSpends = [Double](repeating: 0, count: 12)
        
        let today = Date()
        for index in userDetails!.expenses.indices{
            if userDetails!.expenses[index].date >= Calendar.current.date(byAdding: Calendar.Component.day, value: -365, to: today)!{
                let monthComp = Calendar.current.component(.month, from: userDetails!.expenses[index].date)
                if userDetails!.expenses[index].category == CategoryEnum.Income{
                    monthSpends[monthComp-1] += Double(userDetails!.expenses[index].amount)
                }else{
                    monthSpends[monthComp-1] -= Double(userDetails!.expenses[index].amount)
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
    
    private func getExpenses(for days: Int)-> Float{
        let userExpenses = userDetails!.expenses
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
}

extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

