//
//  BooksViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 6.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let firestore = Firestore.firestore()
    let auth = Auth.auth()
    var books : [Book] = []
        
    
    var booksDocs : [QueryDocumentSnapshot]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookTableViewCell = bookTableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)

      
       var bookListContentConfiguration = bookTableViewCell.defaultContentConfiguration()
       bookListContentConfiguration.text = books[indexPath.row].bookName
       
       bookListContentConfiguration.secondaryText = books[indexPath.row].bookAuthor
        bookListContentConfiguration.textProperties.color = ColorRGBConstants.riceWine
        bookListContentConfiguration.secondaryTextProperties.color = ColorRGBConstants.riceWine
       bookTableViewCell.contentConfiguration = bookListContentConfiguration
       

        return bookTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bookTableView.cellForRow(at: indexPath)?.selectionStyle = .none
        self.performSegue(withIdentifier: "goToBookDetail", sender: self)
    }
    
    @IBOutlet weak var bookTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchBooks() //bunu düzelt
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTableView.delegate = self
        bookTableView.dataSource = self
        configureNavigationBarTitle(title: "Your Books")
        configureNavigationRightBarButtonItem()
    }
    func fetchBooks() {
        guard let userIDSafe = auth.currentUser?.uid else {return}
        firestore.collection("users").document(userIDSafe).collection("books").getDocuments { querySnapshot, error in
            guard let querySnapshotSafe = querySnapshot else {return}
            let docs = querySnapshotSafe.documents
            self.booksDocs = docs
            guard let safeBooksDocs = self.booksDocs  else {return}
            
            DispatchQueue.main.async {
                self.books = safeBooksDocs.map({ snapshot in
                    let data = snapshot.data()
                    let documentID = snapshot.documentID
                    let name = data["bookName"] as! String
                    let author = data["bookAuthor"] as! String
                    let bookDescription = data["bookDescription"] as! String
                    let bookDate = data["bookAddedDate"] as! String
                    return Book(id: documentID ,bookName: name, bookAuthor: author, bookDescription: bookDescription, bookAddedDate: bookDate)
                })
                self.bookTableView.reloadData()
            }
        }
    }
    
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    func configureNavigationRightBarButtonItem() {
        let addBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addBookBarButtonTapped))
        addBarButtonItem.tintColor = ColorRGBConstants.riceWine
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc func addBookBarButtonTapped() {
        self.performSegue(withIdentifier: "addBookPage", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let destinationVC = segue.destination as? BookDetailViewController
        if let indexPath = bookTableView.indexPathForSelectedRow  {
            guard let safeDestinationVC = destinationVC else {return}
            guard let safeBookDocId = books[indexPath.row].id else {return}
            safeDestinationVC.bookDocID = safeBookDocId
            safeDestinationVC.bookAuthor = books[indexPath.row].bookAuthor
            safeDestinationVC.bookName = books[indexPath.row].bookName
            safeDestinationVC.bookBio = books[indexPath.row].bookDescription
            safeDestinationVC.bookTableView = bookTableView
        }
        
        
    }
    

}
