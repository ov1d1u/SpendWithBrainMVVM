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

    private var infoView : ShowInfoViewController?
    private var expenseViewModel : ExpenseViewModel! {
        didSet{
            amountLabel.text = expenseViewModel.totalExpense
            chart.data = expenseViewModel.pieDataSet
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserData(_:)), name: Notification.Name(rawValue: "refreshExpenseScreen"), object: nil)
        fillWithStartData(7)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customize()
        self.navigationController?.navigationBar.topItem?.title = "My Expenses"
    }
    
    @objc func refreshUserData(_ notification: Notification){
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
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
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
    }
    
    private func fillWithStartData(_ days : Int){
        expenseViewModel = ExpenseViewModel(user: LocalDataBase.getUserInfo()!, period: days)
        table.reloadData()
    }
    
    
    
    private func customize(){
        segmentControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        segmentControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
        chart.legend.enabled = false
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        chart.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chart.data?.setValueTextColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        let pieChartAttribute = [ NSAttributedString.Key.font: UIFont(name: "Arial", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 0.462, green: 0.838, blue: 1.000, alpha: 1) ]
        let pieChartAttrString = NSAttributedString(string: "Quarterly Revenue", attributes: pieChartAttribute)
        chart.centerAttributedText = pieChartAttrString
    }
    
    @objc func selectOneExpense(_ sender:UITapGestureRecognizer){
        let showDialog = ShowInfo()
        let showVC = showDialog.alert()
        let cell = sender.view as! CustomTableViewCell
        showVC.setData(cell.cellViewModel)
        present(showVC, animated: true)
    }
}
extension ExpensesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseViewModel.expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "custom") as! CustomTableViewCell
        cell.cellViewModel = CellViewModel(expense: expenseViewModel.expenses[indexPath.row],soldAfterThis : expenseViewModel.getSoldForThisExpense(at: indexPath.row))
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(selectOneExpense(_:)))
        cell.addGestureRecognizer(tapGest)
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
