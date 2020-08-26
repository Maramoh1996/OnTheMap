//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Maram Moh on 28/06/2020.
//  Copyright © 2020 Maram Moh. All rights reserved.
//

import UIKit

class LoginViewController: ViewController {
    
    
    @IBOutlet var userName : UITextField!
    @IBOutlet var passWord : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        passWord.delegate = self
    }
    
    
    @IBAction func logIn(_ sender: UIButton) {
        UdacityAPI.postSession(username: userName.text!, password: passWord.text!) { (respons, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "You Have Entered Wrong Information")
                }
                
                return
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Login", sender: nil)
        }
    }
    


    }




@IBAction func signUp(_ sender: Any) {
    if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

}
