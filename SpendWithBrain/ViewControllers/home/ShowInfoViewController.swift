//
//  ShowInfoViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 26/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class ShowInfoViewController: UIViewController {
    @IBOutlet weak var catImg: UIImageView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var stackCat: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    
    private var cell : CustomTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        if cell != nil {
            catImg.image = cell?.imgCat.image
            catLbl.text = cell?.category.text
            details.text = cell?.details
            amount.text = cell?.amount.text
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd at HH:mm"
            date.text = String(dateFormat.string(from: (cell?.date)!))
            photoImg.image = getImage(imageName: (cell?.imagePath)!)
        }
        stackCat.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        stackCat.layer.cornerRadius = 4
        stackCat.layer.borderWidth = 1
        stackCat.layer.borderColor = #colorLiteral(red: 0.05566834658, green: 0.7084309459, blue: 0.5218427777, alpha: 1)
    }
    
    func getImage(imageName : String)-> UIImage{
        let fileManager = FileManager.default
        // Here using getDirectoryPath method to get the Directory path
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        }else{
            print("No Image available")
            return #imageLiteral(resourceName: "chitanta.png") // Return placeholder image here
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func setData(_ cell : CustomTableViewCell){
        self.cell = cell
    }
    @IBAction func deleteClick(_ sender: UIButton) {
        deleteDirectory(directoryName: (cell?.imagePath)!)
        LocalDataBase.deleteExpense((cell?.date)!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshUserData"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshExpenseScreen"), object: nil)
        dismiss(animated: true)
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func deleteDirectory(directoryName : String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directoryName)
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            print("Directory not found")
        }
    }

}
