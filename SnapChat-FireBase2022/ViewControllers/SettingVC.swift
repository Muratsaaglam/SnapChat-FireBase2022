//
//  SettingVC.swift
//  SnapChat-FireBase2022
//
//  Created by Murat Sağlam on 16.02.2022.
//

import UIKit
import Firebase

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        //LogOut
        do {
                   try Auth.auth().signOut()
                   self.performSegue(withIdentifier: "toSignInVC", sender: nil)
               } catch {
                   
               }
    }
}
