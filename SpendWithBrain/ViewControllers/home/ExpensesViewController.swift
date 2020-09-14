//
//  ExpensesViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 21/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var chart: PieChartView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var table: UITableView!

    private var infoView : ShowInfoViewController?
    private var expenseViewModel = ExpenseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        expenseViewModel.delegate = self
        expenseViewModel.initUserAndPeriod(forPeriod: 7)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customize()
        self.navigationController?.navigationBar.topItem?.title = "My Expenses"
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: print("Selected week info")
        expenseViewModel.setModel(forPeriod: 7)
        case 1: print("Selected month info")
        expenseViewModel.setModel(forPeriod: 30)
        case 2: print("Selected year info")
        expenseViewModel.setModel(forPeriod: 365)
        default:
            break
        }
    }
    
    private func customize(){
        segmentControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        segmentControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
        chart.legend.enabled = false
        let pieChartAttribute = [ NSAttributedString.Key.font: UIFont(name: "Arial", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 0.462, green: 0.838, blue: 1.000, alpha: 1) ]
        let pieChartAttrString = NSAttributedString(string: "Quarterly Revenue", attributes: pieChartAttribute)
        chart.centerAttributedText = pieChartAttrString
    }
}
extension ExpensesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseViewModel.model?.expenses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "custom") as! CustomTableViewCell
        cell.expense = expenseViewModel.model!.expenses[indexPath.row]
        cell.setUI(expenseViewModel.getSoldForThisExpense(at: indexPath.row))
        cell.delegate = self
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ExpensesViewController : RefreshViewModelDelegate,ShowInfoDelegate{
    func show(_ expense: Expense) {
        let showDialog = ShowInfo()
        let showVC = showDialog.alert()
        showVC.expense = expense
        present(showVC, animated: true)
    }
    
    func refreshUI() {
        amountLabel.text = expenseViewModel.model?.totalExpense
        chart.data = expenseViewModel.model?.pieDataSet
        table.reloadData()
    }
    
    func delete(_ expense: Expense) {
        expenseViewModel.deleteThisExpense(expense: expense)
    }
}
