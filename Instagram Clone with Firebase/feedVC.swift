//
//  FirstViewController.swift
//  Instagram Clone with Firebase
//
//  Created by Atıl Samancıoğlu on 17/12/2016.
//  Copyright © 2016 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userArray = [String]()
    var postImageArray = [String]()
    var postTextArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromServer()
    
    }
    
    func getDataFromServer() {
        
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: {(snapshot) in
         
            
            let values = snapshot.value! as! NSDictionary
            
            let posts = values["posts"] as! NSDictionary
            
            let postIDs = posts.allKeys
            
            for id in postIDs {
                
                let singlePost = posts[id] as! NSDictionary
                
                self.userArray.append(singlePost["postedby"] as! String)
                self.postTextArray.append(singlePost["posttext"] as! String)
                self.postImageArray.append(singlePost["image"] as! String)
                
            }
            
            self.tableView.reloadData()
           
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cell
        
        cell.postText.text = postTextArray[indexPath.row]
        cell.userNameLabel.text = userArray[indexPath.row]
        cell.postImage.sd_setImage(with: URL(string: self.postImageArray[indexPath.row]))
        
        return cell
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "userinfo")
        UserDefaults.standard.synchronize()
        
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        
        delegate.rememberLogin()
        
        
    }


}

