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
    var bugdetViewModel  : HomeViewModel! {
        didSet{
            currentBalanceLbl.text = bugdetViewModel.currentBalance
            todayExp.text = bugdetViewModel.todayExpense
            weekExp.text = bugdetViewModel.weekExpense
            monthExp.text = bugdetViewModel.monthExpense
            chartDetails.data = bugdetViewModel.dataSetChart
            chartDetails.xAxis.valueFormatter = IndexAxisValueFormatter(values: bugdetViewModel.xValueChart)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserData(_:)), name: Notification.Name(rawValue: "refreshUserData"), object: nil)
        customize()
        bugdetViewModel = HomeViewModel(user: LocalDataBase.getUserInfo()!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "My Budget"
        if(bugdetViewModel.isNewUser()){
            AlertService.showAlert(style: .alert, title: "Hello, dear user", message: "Now you have no expenses, to start see the Add button at the top right.")
        }
    }
    
    @objc func refreshUserData(_ notification: Notification){
        bugdetViewModel = HomeViewModel(user: LocalDataBase.getUserInfo()!)
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
}


