//
//  HomeViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 20/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController, ShowGreetingMessage{

    @IBOutlet weak var currentBalanceViewContainer: UIView!
    @IBOutlet weak var todatExpenseViewContainer: UIView!
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var todayExp: UILabel!
    @IBOutlet weak var weekExp: UILabel!
    @IBOutlet weak var monthExp: UILabel!
    @IBOutlet weak var chartDetails: BarChartView!
    var bugdetViewModel  : HomeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        
        bugdetViewModel = HomeViewModel()
        bugdetViewModel.delegate = self
        bugdetViewModel.delegateGreeting = self
        bugdetViewModel.initializeUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "My Budget"
    }
    
    func showGreeting(){
        AlertService.showAlert(style: .alert, title: "Hello, dear user", message: "Now you have no expenses, to start see the Add button at the top right.")
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

extension HomeViewController : RefreshViewModelDelegate {
    func refreshUI() {
        guard let vm = bugdetViewModel ,let model = vm.model else {return}
        currentBalanceLbl.text = model.currentBalance
        todayExp.text = model.todayExpense
        weekExp.text = model.weekExpense
        monthExp.text = model.monthExpense
        chartDetails.data = model.dataSetChart
        chartDetails.xAxis.valueFormatter = IndexAxisValueFormatter(values: model.xValueChart)
    }
}

protocol ShowGreetingMessage {
    func showGreeting()
}


