//
//  QuotesDetailViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 23.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreData

class QuotesDetailViewController: UIViewController {
    
    
    @IBOutlet weak var quoteTitleLabel: UILabel!
    
    
    @IBOutlet weak var quoteDescriptionLabel: UILabel!
    
    var quoteTitle : String = ""
    var quoteDescription : String = ""
    var quoteTableView : UITableView? = nil
    var quoteBookName : String = ""
    var quoteDocId : String = ""
    var quoteId : String = ""
    var bookDocId : String = ""
    let firebaseFirestore = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var isFavorite = false
    var currentQuoteCoreDataIndex = 0
    
    lazy var coreDataQuoteArray : [QuoteCoreData] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var quoteDetailFavoriteIcon: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        quoteTitleLabel.text = quoteTitle
        quoteDescriptionLabel.text = quoteDescription
        //navigaiton bar title ayarla
        
        
        configureNavigationBarTitle(title: "\(quoteTitle) Quote Detail")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDataQuoteArray = []
        isBookFavorite()
    }
    
    @IBAction func deleteQuoteButtonPressed(_ sender: UIButton) {
        guard let safeTableView = quoteTableView else {return}
        guard let safeAuthId = firebaseAuth.currentUser?.uid else {return}
        firebaseFirestore.collection("users").document(safeAuthId).collection("books").document(bookDocId).collection("quotes").document(quoteDocId).delete()
        
        context.delete(coreDataQuoteArray[currentQuoteCoreDataIndex])
        saveQuotesToFavoriteLocal()
        
        safeTableView.reloadData()
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
    
    @IBAction func quoteDetailFavoriteButtonPressed(_ sender: UIBarButtonItem) {
        makeQuoteFavorite()
    }
    
    func makeQuoteFavorite() {
        isFavorite.toggle()
        if isFavorite {
            guard let safeButtonImage = UIImage(systemName: "star.fill") else {return}
            quoteDetailFavoriteIcon.image = safeButtonImage
           
            let quoteCoreDataModel = QuoteCoreData(context: context)
            quoteCoreDataModel.quoteTitle = quoteTitle
            quoteCoreDataModel.quoteDescription = quoteDescription
            quoteCoreDataModel.quoteBookName = quoteBookName
            quoteCoreDataModel.quoteBookId = bookDocId
            quoteCoreDataModel.quoteId = quoteId
            saveQuotesToFavoriteLocal()
        }
        else {
            guard let safeButtonImage = UIImage(systemName: "star") else {return}
            quoteDetailFavoriteIcon.image = safeButtonImage
            context.delete(coreDataQuoteArray[currentQuoteCoreDataIndex])
            saveQuotesToFavoriteLocal()
        }
        isBookFavorite()
    }
    
    func fetchQuotes() {
        let quoteRequest : NSFetchRequest<QuoteCoreData> = QuoteCoreData.fetchRequest()
        loadQuotes(request: quoteRequest)
    }
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func isBookFavorite() {
        fetchQuotes()
        coreDataQuoteArray.forEach { quote in
            if quote.quoteBookName == quoteBookName {
                if quote.quoteTitle == quoteTitle {
                    if quote.quoteDescription == quoteDescription {
                        isFavorite = true
                    }
                    else {
                        isFavorite = false
                        currentQuoteCoreDataIndex += 1
                    }
                }
                else{
                    isFavorite = false
                    currentQuoteCoreDataIndex += 1
                }
                
            }
            else {
                isFavorite = false
                currentQuoteCoreDataIndex += 1
            }
        }
        if isFavorite {
            quoteDetailFavoriteIcon.image = UIImage(systemName: "star.fill")
        }
        else {
            quoteDetailFavoriteIcon.image = UIImage(systemName: "star")
        }
        
    }
    
    func saveQuotesToFavoriteLocal(){
        //coredata saving
        do {
            try context.save()
        } catch {
            print("error saving book favorite local \(error)")
        }
    }
    func loadQuotes(request : NSFetchRequest<QuoteCoreData>)  {
        
        do{
            let fetchedData = try context.fetch(request)
            coreDataQuoteArray = fetchedData
        } catch {
            print("quote core data fetch error")
        }
    }
    
}
