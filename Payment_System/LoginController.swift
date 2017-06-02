//
//  ViewController.swift
//  Payment_System
//
//  Created by Iliyan on 5/19/17.
//  Copyright © 2017 Iliyan. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
   
    var loggedIn = false;
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginBut: UIButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        loginBut.layer.cornerRadius = 5
        loginBut.layer.borderWidth = 1
    }

    func performLogIn() {
        let username = emailField.text!
        let password = passField.text!
        
        
        if(username == "" || password == "") {
            return
        } else {
        
        
        let loginString = String(format: "%@:%@", username, password)
        
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
                let status = response as? HTTPURLResponse
                if status?.statusCode != 200 {
                    DispatchQueue.main.async{
                    self.displayCredentialMessage()
                    }
                }
                else
                {
                    print("Success connection")
                    UserDefaults.standard.set(true, forKey: "isUserLogged")
                    UserDefaults.standard.set(username, forKey: "CurrentUser")
                    UserDefaults.standard.set(password,forKey:"CurrentUserPassword")
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            task.resume()
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func LogIn(_ sender: UIButton) {
        performLogIn()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! Batches
        controller.userName = emailField.text!
}
    
    func displayCredentialMessage() {
        let alert = UIAlertController(title: "Error", message: "Incorrect credentials", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
    
}



