//
//  SignupInfoViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 4.01.2023.
//

import UIKit
import Foundation

class SignupInfoViewController: UIViewController {
    
    @IBOutlet weak var showImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var bioTextField: UITextField!
    
    var nameString = ""
    var bioString = ""
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.tag = 0
        bioTextField.tag = 1
        nameTextField.layer.cornerRadius = CornerRadiusConstants.textFieldCornerRadius
        nameTextField.clipsToBounds = true
        bioTextField.layer.cornerRadius = CornerRadiusConstants.textFieldCornerRadius
        bioTextField.clipsToBounds = true
        nextButton.layer.cornerRadius = CornerRadiusConstants.buttonCornerRadius
        nextButton.clipsToBounds = true
        showImageView.layer.cornerRadius = CornerRadiusConstants.imageViewCornerRadius
        showImageView.clipsToBounds = true
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        checkAllComponentsAndGo()
        
    }
    
    func checkAllComponentsAndGo() {
        if  showImageView.image == nil {
            let alert = BooklyAlert.presentAlert(alertTitle: "photo cannot be empty", alertMessage: "please put something")
            self.present(alert, animated: true)
            
        }
        if nameTextField.text?.isEmpty == true  {
            let alert = BooklyAlert.presentAlert(alertTitle: "name cannot be empty", alertMessage: "please put something")
            self.present(alert, animated: true)
            
        }
        if bioTextField.text?.isEmpty == true {
            let alert = BooklyAlert.presentAlert(alertTitle: "bio cannot be empty", alertMessage: "please put something")
            self.present(alert, animated: true)
        }
        bioString = bioTextField.text ?? ""
        nameString = nameTextField.text ?? ""
        self.performSegue(withIdentifier: "goToSignup", sender: self)
    }
    
    
    
    @IBAction func pickImageButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destinationVC = segue.destination as? SignupViewController {
            print("done")
            destinationVC.name = nameString
            destinationVC.bio = bioString
            destinationVC.image = selectedImage
            
        }
    }
    

}
