//
//  FeedVC.swift
//  SnapChat-FireBase2022
//
//  Created by Murat Sağlam on 16.02.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //Fire Store
    let fireStoreDatabase = Firestore.firestore()
    //Snap Array
    var snapArray = [Snap]()
    var chosenSnap: Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getUserInfo()
        getSnapFromFirebase()
    }
    
    func getSnapFromFirebase()
    {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error" )
                
            }
            else
            {
                if snapshot?.isEmpty == false && snapshot != nil
                {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents
                    {
                        let documendId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String
                        {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]
                            {
                                if let date = document.get("date") as? Timestamp
                                {
                                    
                                    //Time Loop kaç saat önce yayınladı bunu bulan kod dizilimi
                                    if let diffrence = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour
                                    {
                                        if diffrence >= 24
                                        {
                                            self.fireStoreDatabase.collection("Snaps").document(documendId).delete { (error) in
                                                
                                            }
                                        }
                                        else
                                        {
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - diffrence)
                                            self.snapArray.append(snap)
                                        }
                                        
                                     
                                       
                                    }
                                  
                                }
                            }
                        }
                        

                    }
                    self.tableView.reloadData()
                    
                }
                
                
            }
        }
        
        
    }
    
    
    func getUserInfo()
    {
        //Username corresponding to Firebase EMail
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error  != nil
            {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                
            }
            else
            {
                if snapshot?.isEmpty == false && snapshot != nil
                {
                    for document in snapshot!.documents
                    {
                        if let username=document.get("username") as? String
                        {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                            
                        }
                        
                    }
                    
                    
                }
            }
            
            
        }
        
        
        
    }
    
    
    func makeAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //TABLE VIEW FUNC
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toSnapVC"
        {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap  = chosenSnap
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
    
    
}



