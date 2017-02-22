//
//  ViewController.swift
//  SwiftSample
//
//  Created by qbuser on 15/02/17.
//  Copyright © 2017 qbuser. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignUpVC: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameField {
            self.emailField.becomeFirstResponder()
        }
        else if textField == self.emailField
        {
            self.passwordField.becomeFirstResponder()
        }
        else
        {
            self.signUpAction(self)
        }
        return true
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.startAnimating()

        BaseService.requestPOSTURL(root+signUpMethod, params: ["name" : nameField.text! as AnyObject, "email" : emailField.text! as AnyObject, "password" : passwordField.text! as AnyObject], headers:["Content-Type" :"application/json"] , success: { (response) in
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
}

