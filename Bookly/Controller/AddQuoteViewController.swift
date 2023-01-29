//
//  AddQuoteViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 23.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddQuoteViewController: UIViewController, UITextFieldDelegate {
    
    let firebaseFirestore = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    var bookId : String? = nil
    

    @IBOutlet weak var quoteTitle: UITextField!
    @IBOutlet weak var quoteDescription: UITextField!
    
    var quoteTitleTextFieldString : String = ""
    var quoteDescriptionTextFieldString : String = ""
    var quiteBookName : String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        quoteTitle.delegate = self
        quoteDescription.delegate = self
        configureNavigationBarTitle(title: "Add Quote")
    }
    
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 0 {
            guard let safeTextFieldText = textField.text else {return}
            quoteTitleTextFieldString = safeTextFieldText
            
        }
        if textField.tag == 1 {
            guard let safeTextFieldText = textField.text else {return}
            quoteDescriptionTextFieldString = safeTextFieldText
        }
    }
    
    
   
    @IBAction func quoteAddButtonPressed(_ sender: UIButton) {
        if quoteTitleTextFieldString.isEmpty {
            return
        }
        if quoteDescriptionTextFieldString.isEmpty {
            return
        }
        guard let safeUserId = Auth.auth().currentUser?.uid else {return}
        guard let safeBookName = quiteBookName  else {return}
        guard let safeBookId = bookId else {return}
        let quoteModel = Quote(bookId: safeBookId, quoteTitle: quoteTitleTextFieldString, quoteDescription: quoteDescriptionTextFieldString, quoteBookName: safeBookName)

        do{
            try firebaseFirestore.collection("users").document(safeUserId).collection("books").document(safeBookId).collection("quotes").document().setData(from: quoteModel)
        } catch {
            print("error while adding quote")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
