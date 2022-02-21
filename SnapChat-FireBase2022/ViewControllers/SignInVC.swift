//
//  ViewController.swift
//  SnapChat-FireBase2022
//
//  Created by Murat Sağlam on 16.02.2022.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SnapChat Login"
        view.backgroundColor = .systemBackground
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if passwordText.text != "" && emailText.text != ""
        {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
                if error != nil
                {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                else
                {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
            
        }
        else
        {
            
            self.makeAlert(title: "Error", message: "Password/E-mail Is Not Null!")
            
        }
        
        
    }
    
    @IBAction func singUpClicked(_ sender: Any) {
        
        //User information Check and Register
        if userNameText.text != "" && passwordText.text != "" && emailText.text != ""
        {
            //User Creatived
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { [self] (auth, error ) in
                if error != nil
                {
                    self.makeAlert(title: "Erroe", message: error?.localizedDescription ?? "Error" )
                }
                else
                {
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email": self.emailText.text!, "username": self.userNameText.text!] as [String : Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil
                        {
                            
                        }
                    }
                    
                    // Created User next to Page
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
        else
        {
            //Is Not Null Error
            self.makeAlert(title: "Error", message: "Username/Password/E-Mail Is Not Null!")
            
        }
        
        
        
        
        
        
        
    }
    
    
    func makeAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

