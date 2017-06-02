//
//  Batches.swift
//  Payment_System
//
//  Created by Iliyan on 5/19/17.
//  Copyright © 2017 Iliyan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Batches:UIViewController,UITableViewDataSource,UITableViewDelegate {
    //Hardcoded Testing json not working still
    let idArray = ["100010002001","100010002000","100010002003"]
    let holder = "Test Two"
    let refArray = ["RAPL-011:Of.02","RAPL-012:Of.03","RAPL-026:At.12"]
    let balanceArray = [3285.55,0.00,393.36]
    let activeArray = ["true","false","true"]
    var userName:String = ""
    var selectedId:String?
    var Accdata = [AccountsData]()
   private  var propCount = 0
   private var balCount = 0
   private var idCount = 0
    
    @IBOutlet weak var FilterBar: UISearchBar!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountButt: UIButton!
    @IBOutlet weak var propertyButt: UIButton!
    @IBOutlet weak var balanceButt: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountButt.layer.borderWidth = 0.5
        accountButt.layer.borderColor = UIColor.black.cgColor
        propertyButt.layer.borderWidth = 0.5
        propertyButt.layer.borderColor = UIColor.black.cgColor
        balanceButt.layer.borderWidth = 0.5
        balanceButt.layer.borderColor = UIColor.black.cgColor


        
        createAccountArray()
    }
    
    
    func createAccountArray() {
        for i in 0..<idArray.count {
            let newAcc = AccountsData(id: idArray[i], refNum: refArray[i], balance: balanceArray[i], holder: holder)
            Accdata.append(newAcc)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLogged")
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .all
        }
        print("Batches \(isUserLoggedIn)")
        if(!isUserLoggedIn) {
            performSegue(withIdentifier: "LoginController", sender: self)
        } else {
            userLbl.text = UserDefaults.standard.object(forKey: "CurrentUser") as? String
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // TABLE SORTING
    func sortAccountASCbyBalance() {
        Accdata = self.Accdata.sorted(by: { $0._balance < $1._balance})
        tableView.reloadData()
    }
    
    func sortAccountDESCbyBalance() {
        Accdata = self.Accdata.sorted(by: { $0._balance > $1._balance})
        tableView.reloadData()
    }
    func sortAccountASCbyID() {
        Accdata = self.Accdata.sorted(by: { $0._id < $1._id})
        tableView.reloadData()
    }
    func sortAccountDESCbyID() {
        Accdata = self.Accdata.sorted(by: { $0._id > $1._id})
        tableView.reloadData()
    }
    func sortAccountASCbyRefNum(){
        Accdata = self.Accdata.sorted(by: { $0._refNum < $1._refNum})
        tableView.reloadData()
    }
    func sortAccountDESCbyRefNum() {
        Accdata = self.Accdata.sorted(by: { $0._refNum > $1._refNum})
        tableView.reloadData()
    }
    
    
    @IBAction func sortAccounts(_ sender: UIButton) {
        idCount += 1
        balanceButt.setTitle("Салдо", for: .normal)
        balCount = 0
        propertyButt.setTitle("Имот", for: .normal)
        propCount = 0
        switch idCount {
        case 1:accountButt.setTitle("Партида ↓", for: .normal)
               sortAccountDESCbyID()
        case 2: accountButt.setTitle("Партида ↑", for: .normal)
               sortAccountASCbyID()
        case 3: accountButt.setTitle("Партида", for: .normal)
        idCount = 0
        default: break
        }
    }
    
    
    @IBAction func sortProperty(_ sender: UIButton) {
        propCount += 1
        balanceButt.setTitle("Салдо", for: .normal)
        balCount = 0
        accountButt.setTitle("Партида", for: .normal)
        idCount = 0
        switch propCount {
        case 1: propertyButt.setTitle("Имот ↓", for: .normal)
                sortAccountDESCbyRefNum()
        case 2: propertyButt.setTitle("Имот ↑", for: .normal)
                sortAccountASCbyRefNum()
        case 3: propertyButt.setTitle("Имот", for: .normal)
        propCount = 0
        default: break
        }
        
        
    }
    
    @IBAction func sortBalance(_ sender: UIButton) {
        balCount += 1
        accountButt.setTitle("Партида", for: .normal)
        idCount = 0
        propertyButt.setTitle("Имот", for: .normal)
        propCount = 0
        switch balCount {
        case 1: balanceButt.setTitle("Салдо ↓", for: .normal)
                sortAccountDESCbyBalance()
        case 2: balanceButt.setTitle("Салдо ↑", for: .normal)
                sortAccountASCbyBalance()
        case 3: balanceButt.setTitle("Салдо", for: .normal)
                balCount = 0
        default: break
        }
    }
    
    

    @IBAction func SettingsButton(_ sender: UIBarButtonItem) {
        
        UserDefaults.standard.set(false, forKey: "isUserLogged")
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
        UserDefaults.standard.removeObject(forKey: "CurrentUserPassword")
        self.performSegue(withIdentifier: "LoginController", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Accdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AccountCell
        cell.idField.text = Accdata[indexPath.row]._id
        cell.nameField.text = Accdata[indexPath.row]._holder
        cell.refField.text = Accdata[indexPath.row]._refNum
        cell.balanceField.text =  String(format:"%.2f", Accdata[indexPath.row]._balance)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
        selectedId = Accdata[indexPath.row]._id
        performSegue(withIdentifier: "clientReport", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clientReport" {
            let controller = segue.destination as! Client_Report
            controller.id = selectedId!
        }
    }
}







/* func downloadJsonWithTask() {
 let user = "test.2@gm.com"
 let password = "qwerty"
 let loginString = String(format: "%@:%@", user, password)
 
 let loginData = loginString.data(using: String.Encoding.utf8)!
 
 let base64LoginString = loginData.base64EncodedString()
 
 
 
 let baseUrl = "http://vrod.dobritesasedi.bg/rest/accounts/100010002001/statement"
 
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
 print(myJson)
 }
 catch {
 print("catch block")
 }
 }
 }
 
 
 }
 
 task.resume()
 
 }*/
