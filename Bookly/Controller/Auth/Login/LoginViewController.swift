//
//  LoginViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 1.01.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var emailTextString : String = ""
    var passwordTextString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        indicatorView.isHidden = true
        emailTextField.tag = 0
        passwordTextField.tag = 1
        passwordTextField.isSecureTextEntry = true
        emailTextField.layer.cornerRadius = CornerRadiusConstants.textFieldCornerRadius
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = CornerRadiusConstants.textFieldCornerRadius
        passwordTextField.clipsToBounds = true
        loginButton.layer.cornerRadius = CornerRadiusConstants.buttonCornerRadius
        loginButton.clipsToBounds = true
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToHome", sender: self)
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
    checkAllComponentsAndLoginUser()
       // self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 0 {
            guard let emailText = emailTextField.text else {return}
            emailTextString = emailText
        }
        else {
            guard let passwordText = passwordTextField.text else {return}
            passwordTextString = passwordText

        }
    }
    
    func checkAllComponentsAndLoginUser() {
        if emailTextField.text?.isEmpty == true  {
            let alert = BooklyAlert.presentAlert(alertTitle: "email cannot be empty", alertMessage: "please put something")
            self.present(alert, animated: true)
            return
            
        }
        if passwordTextField.text?.isEmpty == true {
          let alert = BooklyAlert.presentAlert(alertTitle: "password cannot be empty", alertMessage: "please put something")
          self.present(alert, animated: true)
            return
        }
        loginUser()

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
      
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    func loginUser() {
        indicatorView.isHidden = false
        Auth.auth().signIn(withEmail: emailTextString, password: passwordTextString) {
            authResult, error in
            if error != nil {
                print("error login")
                return
            }
            else
            {
                self.indicatorView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                })
                self.performSegue(withIdentifier: "goToHome", sender: self)
                
            }
        
        }
    }
    

}
