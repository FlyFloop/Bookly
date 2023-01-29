//
//  ViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 1.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = CornerRadiusConstants.buttonCornerRadius
        loginButton.clipsToBounds = true
        signupButton.layer.cornerRadius = CornerRadiusConstants.buttonCornerRadius
        signupButton.clipsToBounds = true
        
    }

    @IBAction func goToSignup(_ sender: Any) {
        self.performSegue(withIdentifier: "goToInfo", sender: self)
    }
    
}

