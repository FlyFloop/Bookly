//
//  QuotesViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 24.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class QuotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    let firestore = Firestore.firestore()
    let auth = Auth.auth()
    
    var quotes : [Quote] = []
    
    @IBOutlet weak var quotesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        self.navigationItem.title = "My Quotes"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllQuotes()
        configureNavigationBarTitle(title: "All Quotes")
    }
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func fetchAllQuotes() {
        quotes = [] //ekranı açarken 0lanması gerekiyor yoksa aynı nesne defalarca ekleniyor
        
        guard let userIDSafe = auth.currentUser?.uid else {return}
        
        firestore.collection("users").document(userIDSafe).collection("books").getDocuments { snapShot, error in
            guard let safeSnapShot = snapShot else {return}
            
            let docs = safeSnapShot.documents
            
            docs.forEach { queryDocSnapshot in
                let _ = queryDocSnapshot.reference.collection("quotes").getDocuments { quoteSnapShot, error in
                    guard let safeQuoteSnapShot = quoteSnapShot else {return}
                    let quoteDocs = safeQuoteSnapShot.documents
                    DispatchQueue.main.async {
                        quoteDocs.forEach { doc in
                            let data = doc.data()
                            guard let quoteBookName = data["quoteBookName"] as? String else {return}
                            guard let quoteDescription = data["quoteDescription"] as? String else {return}
                            guard let quoteTitle = data["quoteTitle"] as? String else {return}
                            let quoteModel = Quote(quoteTitle: quoteTitle, quoteDescription: quoteDescription, quoteBookName: quoteBookName)
                            self.quotes.append(quoteModel)
                        }
                        self.quotesTableView.reloadData()
                    }
           }
        }
      }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bookTableViewCell = quotesTableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath)
        // bookTableViewCell.backgroundColor = .black
        var bookListContentConfiguration = bookTableViewCell.defaultContentConfiguration()
        bookListContentConfiguration.text = quotes[indexPath.row].quoteTitle
        bookListContentConfiguration.secondaryText = "Belongs to \(quotes[indexPath.row].quoteBookName) book"
        bookListContentConfiguration.textProperties.color = ColorRGBConstants.riceWine
        bookListContentConfiguration.secondaryTextProperties.color = ColorRGBConstants.riceWine
        bookTableViewCell.contentConfiguration = bookListContentConfiguration
        return bookTableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        quotesTableView.cellForRow(at: indexPath)?.selectionStyle = .none
        self.performSegue(withIdentifier: "goToQuoteDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath =  quotesTableView.indexPathForSelectedRow else {return}
        let destinationVC =  segue.destination as! QuotesDetailViewController
        destinationVC.quoteTitle = quotes[indexPath.row].quoteTitle
        destinationVC.quoteDescription = quotes[indexPath.row].quoteDescription
    }
    
    
    
}
    

   


 
 

 
 

