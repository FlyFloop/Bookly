//
//  BookDetailViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 21.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreData
class BookDetailViewController: UIViewController {
    
    var bookName : String = "nil"
    var bookBio : String = "nil"
    var bookAuthor : String = "nil"
    var bookDocID : String = "nil"
    let firebaseFirestore = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var bookTableView : UITableView?

    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookBioLabel: UILabel!
    
    @IBOutlet weak var bookDetailFavoriteButton: UIBarButtonItem!
    
    lazy var coreDataBookArray : [BookCoreData] = []
    lazy var coreDataQuoteArray : [QuoteCoreData] = []

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isFavorite : Bool = false
    
    var currentBookCoreDataIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookNameLabel.text = bookName
        bookBioLabel.text = bookBio
        bookAuthorLabel.text = bookAuthor
        configureNavigationBarTitle(title: "\(bookName) Book Detail")
      
        
        // Do any additional setup after loading the view.
    }
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDataQuoteArray = []
        isBookFavorite()
    }
    
    @IBAction func deleteBookButtonPressed(_ sender: UIButton) {
        guard let safeAuthId = firebaseAuth.currentUser?.uid else {return}
        firebaseFirestore.collection("users").document(safeAuthId).collection("books").document(bookDocID).delete()
        
       
        firebaseFirestore.collection("users").document(safeAuthId).collection("books").document(bookDocID).collection("quotes").getDocuments { querySnapshot, error in
            guard let safeQuerySnapShot = querySnapshot else {return}
            let docs = safeQuerySnapShot.documents
            docs.forEach { snapshot in
                snapshot.reference.delete()
            }
        }
      
        guard let safeTableView = bookTableView else {return}
        if isFavorite {
            saveBooksToFavoriteLocal()
            context.delete(coreDataBookArray[currentBookCoreDataIndex])
        }
        deleteBookQuotesCoreData()
        saveBooksToFavoriteLocal()
        safeTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
        
        
    }
    func fetchQuotes() {
        let quoteRequest : NSFetchRequest<QuoteCoreData> = QuoteCoreData.fetchRequest()
        loadQuotes(request: quoteRequest)
    }
    func loadQuotes(request : NSFetchRequest<QuoteCoreData>)  {
        do{
            let fetchedData = try context.fetch(request)
            coreDataQuoteArray = fetchedData
        } catch {
            print("quote core data fetch error")
        }
    }
    
    func deleteBookQuotesCoreData() {
        fetchQuotes()
        coreDataQuoteArray.forEach { quote in
            if quote.quoteBookId == bookDocID {
                context.delete(quote)
                saveBooksToFavoriteLocal()
             
            }
           
        }
    }
    
    @IBAction func goToQuotesButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToQuotes", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? QuotesTableViewController
        destinationVC?.bookId = bookDocID
        destinationVC?.quoteBookName = bookName
        
    }
    
    @IBAction func bookDetailFavoriteButtonPressed(_ sender: UIBarButtonItem) {
        makeBookFavorite()
        
    }
    
    func isBookFavorite() {
        fetchBooks()
        coreDataBookArray.forEach { book in
            if book.bookName == bookName {
                if book.bookAuthor == bookAuthor {
                    if book.bookDescription == bookBio {
                        isFavorite = true
                    }
                    else {
                        isFavorite = false
                        currentBookCoreDataIndex += 1
                    }
                }
                else{
                    isFavorite = false
                    currentBookCoreDataIndex += 1
                }
                
            }
            else {
                isFavorite = false
                currentBookCoreDataIndex += 1
            }
        }
        if isFavorite {
            bookDetailFavoriteButton.image = UIImage(systemName: "star.fill")
        }
        else {
            bookDetailFavoriteButton.image = UIImage(systemName: "star")
        }
        
    }
    func fetchBooks() {
        let booksRequest : NSFetchRequest<BookCoreData> = BookCoreData.fetchRequest()
        loadBooks(request: booksRequest)
    }
    func loadBooks(request : NSFetchRequest<BookCoreData>)  {
        do{
            let fetchedData = try context.fetch(request)
            coreDataBookArray = fetchedData
        } catch {
            print("book core data fetch error")
        }
    }

    
    func makeBookFavorite()  {
        isFavorite.toggle()
        if isFavorite {
            guard let safeButtonImage = UIImage(systemName: "star.fill") else {return}
            bookDetailFavoriteButton.image = safeButtonImage
            let bookCoreDataModel = BookCoreData(context: context)
            bookCoreDataModel.bookName = bookName
            bookCoreDataModel.bookAuthor = bookAuthor
            bookCoreDataModel.bookDescription = bookBio
            bookCoreDataModel.bookId = bookDocID
            saveBooksToFavoriteLocal()
        }
        else {
            guard let safeButtonImage = UIImage(systemName: "star") else {return}
            bookDetailFavoriteButton.image = safeButtonImage
            context.delete(coreDataBookArray[currentBookCoreDataIndex])
            saveBooksToFavoriteLocal()
        }
        isBookFavorite()
    }

    
 
   
    func saveBooksToFavoriteLocal(){
        //coredata saving
        do {
            try context.save()
        } catch {
            print("error saving book favorite local \(error)")
        }
    }
    
    /*
     
     lazy var coreDataBookArray : [BookCoreData] = []
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     func saveBooksToFavoriteLocal(){
         //coredata saving
         do {
             try context.save()
         } catch {
             print("error saving book favorite local \(error)")
         }
     }
     func loadBooks(request : NSFetchRequest<BookCoreData>)  {
         do{
             let fetchedData = try context.fetch(request)
             coreDataBookArray = fetchedData
         } catch {
             print("fetch error")
         }
     }
     */

    
}
