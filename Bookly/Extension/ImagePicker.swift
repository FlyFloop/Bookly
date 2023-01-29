//
//  ImagePicker.swift
//  Bookly
//
//  Created by Alper Yorgun on 4.01.2023.
//

import Foundation
import UIKit


extension SignupInfoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            showImageView.image = pickedImage
            selectedImage = pickedImage
            dismiss(animated: true) //when the user picks photo, gallery closes
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     dismiss(animated: true)
    }
    
}
