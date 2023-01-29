//
//  HomeTabBarViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 5.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class HomeTabBarViewController: UITabBarController {
    
    let firestore = Firestore.firestore()
    let auth = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        selectedIndex = 0
        tabBarController?.selectedIndex = 0
        self.navigationController?.navigationBar.isHidden = true //2.tabbar açılmasın diye yaptık
        
        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
