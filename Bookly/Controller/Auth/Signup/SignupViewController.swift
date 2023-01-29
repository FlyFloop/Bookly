//
//  SignupViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 1.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

import FirebaseStorage


class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    var emailText : String = ""
    var passwordText : String = ""
    var spinnerBool : Bool = true
    var firestoreRef = Firestore.firestore()
    
    let storageFirebase = Storage.storage().reference()
    
    
    @IBOutlet weak var signupButton: UIButton!
    
    var name = ""
    var bio = ""
    var image = UIImage()
    var profilePhotoUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.tag = 0
        passwordTextField.tag = 1
        passwordTextField.isSecureTextEntry = true
        loadSpinner.isHidden = spinnerBool
        
        emailTextField.layer.cornerRadius = CornerRadiusConstants.textFieldCornerRadius
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = CornerRadiusConstants.textFieldCornerRadius
        passwordTextField.clipsToBounds = true
        signupButton.layer.cornerRadius = CornerRadiusConstants.buttonCornerRadius
        signupButton.clipsToBounds = true
    
        // Do any additional setup after loading the view.
    }
    
    func changeSpinnerView() {
        spinnerBool.toggle()
        loadSpinner.isHidden = spinnerBool
        }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 0 {
            guard let email = emailTextField.text else {return}
            emailText = email
        } else {
            guard let password = passwordTextField.text else {return}
            passwordText = password
        }
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
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        checkAllComponentsAndCreateUser()
      
    }
    
    func checkAllComponentsAndCreateUser() {
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
        createUser()

    }
    //MARK: - Create User
    
    func createUser()  {
        changeSpinnerView()
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { authResult, error in
            if error != nil {
                print("cant login \(String(describing: error))")
                return
            } else {
                
                guard let user = authResult else {return}
                guard let uploadImage = self.image.jpegData(compressionQuality: 50) else {return}
                let ref = self.storageFirebase.child(user.user.uid).child("images").child("0")
                
                self.newImageUrl(completion: { (urlString) in
                    guard let imageSafe = urlString else {
                        print("imagesafe")
                        return}
                    
                    let userModel = UserModel(userName: self.name, userBio: self.bio, email: self.emailText, friendsCount: 0,profilePhoto: imageSafe)
                    do{
                        try self.firestoreRef.collection("users").document(user.user.uid).setData(from: userModel)
                    } catch {
                        print("error while writing user data")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    })
                    self.changeSpinnerView()
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }, ref: ref, uploadImage: uploadImage)
            }
        }
    }
    
    func newImageUrl(completion:@escaping((String?) -> () ), ref : StorageReference, uploadImage: Data) {
        ref.putData(uploadImage) { storage, error in
            guard error == nil else {
                print("fail to upload")
                completion(nil)
                return
            }
            ref.downloadURL { url, error in
                guard let url = url, error == nil else{
                    completion(nil)
                    return
                }
                let urlString = url.absoluteString
                self.profilePhotoUrl = urlString
                print("download url:\(urlString)")
                completion(urlString)
            }
        }
    }
    
   
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
