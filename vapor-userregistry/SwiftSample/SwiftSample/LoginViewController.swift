//
//  LoginViewController.swift
//  SwiftSample
//
//  Created by qbuser on 16/02/17.
//  Copyright © 2017 qbuser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        if textField == self.emailField
        {
            self.passwordField.becomeFirstResponder()
        }
        else
        {
            self.loginButtonAction(self)
        }
        return true
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.startAnimating()
        
        BaseService.requestPOSTURL(root+loginMethod, params: ["email" : emailField.text! as AnyObject, "password" : passwordField.text! as AnyObject], headers:["Content-Type" :"application/json"] , success: { (response) in
            print(response[accessToken])
            self.stopAnimating()
            UserDefaults.standard.setValue(response[accessToken].rawString(), forKey: accessToken)
            UserDefaults.standard.setValue(response["name"].rawString(), forKey: "name")
            print(response["name"])
            print(response)
            AppDelegate.appDelegate().showRoot()
            
        }) { (error) in
            self.stopAnimating()
            let alert = UIAlertController(title: "Error", message:  error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    @IBAction func loginAction(_ sender: Any) {
           }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
