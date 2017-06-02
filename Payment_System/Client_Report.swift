//
//  Client_Report.swift
//  Payment_System
//
//  Created by Iliyan on 5/19/17.
//  Copyright © 2017 Iliyan. All rights reserved.
//

import Foundation
import UIKit



//Hardcoded Testing passed
// let docNumArray = ["5000001026","5000001027","5000001026"]
//let typeArray = ["Invoice","Payment","Payment"]
//let dateArray = ["2017-12-31","2017-12-31","2017-12-31"]
// let appliedArray = ["FullyPaid","FullyPaid","NotPaid"]
// let totalArray = ["789.40 lv.","115.92.lv","305.33"]
// let balanceArray = ["937.15 lv.","1053.07","1358.40"]


class Client_Report:UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var id = " "
    var end_Date = ""
    var start_Date = ""
    var typeArray = [String]()
    var balanceArray = [Double]()
    var totalArray = [Double]()
    var appliedArray = [String]()
    var docNumArray = [String]()
    var issueDateArray = [String]()
    var forwardBalance:Double = 0.0
    @IBOutlet weak var tableView: UITableView!
 
    @IBOutlet weak var docButton: UIButton!
    @IBOutlet weak var totalButton: UIButton!
    @IBOutlet weak var balanceButton: UIButton!

    @IBOutlet weak var endBalanceField: UILabel!
    @IBOutlet weak var beginingBalanceField: UILabel!
    @IBOutlet weak var endDateField: UILabel!
    @IBOutlet weak var startDateField: UILabel!
    @IBOutlet weak var currentBalanceField: UILabel!
    @IBOutlet weak var idField: UILabel!
    @IBOutlet weak var holderField: UILabel!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }

    }
   
    @IBAction func DateFiltering(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter start and end dates", message: "In format yyyy-mm-dd", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addTextField(configurationHandler: {
            (textField1) in
            textField1.text = ""
        })
        
        alert.addAction(UIAlertAction(title: "Filter", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            let textField1 = alert!.textFields![1]
            
            print("Text field: \(textField.text!)")
            
            print(textField1.text!)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:nil))

        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docButton.layer.borderWidth = 0.5
        docButton.layer.borderColor = UIColor.black.cgColor
        totalButton.layer.borderWidth = 0.5
        totalButton.layer.borderColor = UIColor.black.cgColor
        balanceButton.layer.borderWidth = 0.5
        balanceButton.layer.borderColor = UIColor.black.cgColor
        
        print(id)
        downloadJsonWithTask()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docNumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientCell") as! ClientCell
        cell.docNum.text = docNumArray[indexPath.row]
        if appliedArray[indexPath.row] == "FullyPaid" || appliedArray[indexPath.row] == "FullyApplied" {
            cell.applied.text = appliedArray[indexPath.row]
            cell.applied.textColor = UIColor.green
        } else {
            cell.applied.text = appliedArray[indexPath.row]
            cell.applied.textColor = UIColor.red
        }
        cell.date.text = issueDateArray[indexPath.row]
        cell.type.text =  typeArray[indexPath.row]
        cell.total.text = String(format:"%.2f", totalArray[indexPath.row])
        cell.balance.text = String(format:"%.2f", balanceArray[indexPath.row])
        return cell
    }
    
    
    // GETS THE DATA FROM JSON INTO ARRAYs
    func downloadJsonWithTask() {
        let user = UserDefaults.standard.object(forKey: "CurrentUser") as? String
        let password = UserDefaults.standard.object(forKey: "CurrentUserPassword") as? String
        let loginString = String(format: "%@:%@", user!, password!)
        
        let loginData = loginString.data(using: String.Encoding.utf8)!
        
        let base64LoginString = loginData.base64EncodedString()
        
        
        
        let baseUrl = "http://vrod.dobritesasedi.bg/rest/accounts/\(id)/statement"
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl)! as URL)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        
        
        let task = session.dataTask(with: request as URLRequest) {
            
            (data, response, error) in
            
            
            if error != nil {
                print("ERROR")
            }
            else {
                if let content = data
                {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let accStatement = myJson["cssc:AccountStatement"] as? NSDictionary {
                            
                            /*if let account = accStatement["cssc:Account"] as? NSDictionary {
                                if let holder = account["cssc:Holder"] as? NSDictionary {
                                    self.holder = holder["$"]! as! String
                                }
                            }*/
                            
                            
                            if let startDate = accStatement["ct:StartDate"] as? NSDictionary{
                                self.start_Date = startDate["$"]! as! String
                            }
                            if let endDate = accStatement["ct:EndDate"] as? NSDictionary{
                                self.end_Date = endDate["$"]! as! String
                            }
                            if let documents = accStatement["cssc:Documents"] as? AnyObject {
                                if let docArray = documents as? NSArray {
                                    
                                    //Get teh issue dates from json
                                    if let issueDates = docArray.value(forKey:"ft:IssueDate") as? NSArray {
                                        if let iDates = issueDates.value(forKey: "$") as? NSArray {
                                            for item in iDates.dropFirst() {
                                                self.issueDateArray.append(item as! String)
                                            }
                                        }
                                        print("ISSUE Dates\(self.issueDateArray)")
                                    }
                                   //Get the due dates from json NOT USED
                                   // if let dueDates = docArray.value(forKey: "ft:DueDate") as? NSArray{
                                   //     self.dueDateArray = dueDates.value(forKey: "$") as! [String]
                                   //     print("Due Dates\(self.dueDateArray)"  )
                                  //  }
                                    //Get the document numbers from json
                                    if let documentNumbers = docArray.value(forKey: "ft:DocumentNumber") as? NSArray {
                                        //self.docNumArray = documentNumbers.value(forKey: "$") as! [String]
                                        if let dNums = documentNumbers.value(forKey: "$") as? NSArray {
                                            for item in dNums.dropFirst() {
                                                self.docNumArray.append(item as! String)
                                            }
                                        }
                                        print("Document Numbers \(self.docNumArray)")
                                    }
                                    
                                    //Get the Amount from json
                                   // if let amount = docArray.value(forKey: "ft:Amount") as? NSArray {
                                        //self.amountArray = amount.value(forKey: "$") as! [Double]
                                    //    if let amounts = amount.value(forKey: "$") as? NSArray {
                                    //        for item in amounts.dropFirst() {
                                    //            self.amountArray.append(item as! Double)
                                    //        }
                                    //    }
                                   //     print("Amount \(self.amountArray)")
                                   // }
                                    
                                    // Get status of document from json
                                    if let applied = docArray.value(forKey: "ft:Applied") as? NSArray {
                                        if let app = applied.value(forKey: "$") as? NSArray{
                                            for item in app.dropFirst() {
                                                self.appliedArray.append(item as! String)
                                            }
                                        }
                                        print("Applied: \(self.appliedArray)")
                                    }
                                    if let totalAmount = docArray.value(forKey: "ft:TotalAmount") as? NSArray {
                                        if let tAmount = totalAmount.value(forKey: "$") as? NSArray {
                                            for item in tAmount.dropFirst() {
                                                self.totalArray.append(item as! Double)
                                            }
                                        }
                                        print("Total Amount: \(self.totalArray)")
                                    }
                                    if let balance = docArray.value(forKey: "ct:Balance") as? NSArray {
                                        if let balances = balance.value(forKey: "$") as? NSArray {
                                            self.forwardBalance = (balances.firstObject as? Double)!
                                            
                                            for item in balances.dropFirst() {
                                                self.balanceArray.append(item as! Double)
                                            }
                                        }
                                        print("Balance: \(self.balanceArray)")
                                    }
                                    
                                    // docArray.value(forKey:"ft:TotalDiscount")
                                    // docArray.value(forKey:"ft:Type")
                                    if let type = docArray.value(forKey: "ft:Type") as? NSArray {
                                        if let types = type.value(forKey: "$") as? NSArray{
                                            for item in types.dropFirst() {
                                                self.typeArray.append(item as! String)
                                            }
                                        }
                                        print("Types: \(self.typeArray)")
                                    }
                                    DispatchQueue.main.sync{
                                        self.beginingBalanceField.text = String(format:"%.2f", self.forwardBalance)
                                        self.idField.text = self.id
                                        self.currentBalanceField.text = String(format:"%.2f", self.balanceArray.last!)
                                        self.endBalanceField.text = String(format:"%.2f", self.balanceArray.last!)
                                        self.startDateField.text = self.start_Date
                                        self.endDateField.text = self.end_Date
                                        
                                    }
                                    OperationQueue.main.addOperation({
                                     self.tableView.reloadData()
                                        
                                    })
                                    
                                }
                            }
                        }
                    }
                    catch {
                        print("catch block")
                    }
                }
            }
            
            
        }
        
        task.resume()
        
    }
}


