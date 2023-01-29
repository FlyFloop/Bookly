//
//  AddBookViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 21.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class AddBookViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bookNameTextField: UITextField!
    
    @IBOutlet weak var bookAuthorTextField: UITextField!
    
    
    @IBOutlet weak var bookDescriptionTextField: UITextField!
    
    
    var bookNameTextFieldString : String = ""
    var bookAuthorTextFieldString :  String = ""
    var bookDescriptionTextFieldString : String = ""
    var booksCount = 0
    
    let firestore = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarTitle(title: "Add Book")
        bookNameTextField.delegate = self
        bookAuthorTextField.delegate = self
        bookDescriptionTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func addBook() {
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 0 {
            guard let safeTextFieldText = textField.text else {return}
            bookNameTextFieldString = safeTextFieldText
        }
        if textField.tag == 1 {
            guard let safeTextFieldText = textField.text else {return}
            bookAuthorTextFieldString = safeTextFieldText
        }
        if textField.tag == 2 {
            guard let safeTextFieldText = textField.text else {return}
            bookDescriptionTextFieldString = safeTextFieldText
        }
    }
    
    @IBAction func addBookButtonPressed(_ sender: UIButton) {
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))
        if bookNameTextFieldString.isEmpty {
            return
        }
        if bookAuthorTextFieldString.isEmpty {
            return
        }
        if bookDescriptionTextFieldString.isEmpty {
            return
        }
        let bookModel = Book(bookName: bookNameTextFieldString, bookAuthor: bookAuthorTextFieldString, bookDescription: bookDescriptionTextFieldString, bookAddedDate: date)
        guard let userId = Auth.auth().currentUser?.uid else {return}
        firestore.collection("users").document(userId).collection("books").getDocuments { querySnapShot, error in
            guard let safeSnapShot = querySnapShot else {return}
            let data = safeSnapShot.documents.count
            self.booksCount = data
            print(self.booksCount)
        }
        do{
            try firestore.collection("users").document(userId).collection("books").document().setData(from: bookModel)
        } catch {
            print("error while adding book")
        }
        self.navigationController?.popViewController(animated: true)
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
