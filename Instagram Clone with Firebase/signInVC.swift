//
//  signInVC.swift
//  Instagram Clone with Firebase
//
//  Created by Atıl Samancıoğlu on 17/12/2016.
//  Copyright © 2016 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class signInVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
        
        FIRAuth.auth()?.signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                UserDefaults.standard.set(user!.email, forKey: "userinfo")
                UserDefaults.standard.synchronize()
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.rememberLogin()
        
            }
        })
        
        
        
        
        }
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
          
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: passwordText.text! , completion: { (user, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print(user?.email)
                    print(user?.uid)
                }
                
            })
            
        }

    }

}
