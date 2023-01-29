//
//  QuotesTableViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 23.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class QuotesTableViewController: UITableViewController {
    
    
    
    
    let firestore = Firestore.firestore()
    let auth = Auth.auth()
    
    var quotes : [Quote] = []
    var bookId : String = ""
    var quotesDocuments : [QueryDocumentSnapshot]?
    var quoteBookName : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        fetchQuotes()
        guard let safeQuoteBookName = quoteBookName else {return}
        configureNavigationBarTitle(title: "\(String(describing: safeQuoteBookName)) Quotes")
      
    }
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchQuotes()
    }
    func fetchQuotes() {
        guard let userIDSafe = auth.currentUser?.uid else {return}
        firestore.collection("users").document(userIDSafe).collection("books").document(bookId).collection("quotes").getDocuments { querySnapShot, error in
            if error != nil {
                print("firebase fetch quote error")
                return
            }
            guard let safeQuerySnapShot = querySnapShot else {return}
            let docs = safeQuerySnapShot.documents
            self.quotesDocuments = docs
            guard let safeQuotesDocs = self.quotesDocuments else {return}
            
            DispatchQueue.main.async {
                self.quotes = safeQuotesDocs.map({ snapShot in
                    let data = snapShot.data()
                    let quoteId = snapShot.documentID
                    let quoteTitle = data["quoteTitle"] as! String
                    let quoteDescription = data["quoteDescription"] as! String
                    let quoteBookName = data["quoteBookName"] as! String
                    return Quote(id: quoteId, quoteTitle: quoteTitle, quoteDescription: quoteDescription, quoteBookName: quoteBookName)
                })
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath)
        var quoteTableViewCellContentConfiguration = quoteTableViewCell.defaultContentConfiguration()
        
        quoteTableViewCellContentConfiguration.text = quotes[indexPath.row].quoteTitle
        quoteTableViewCellContentConfiguration.secondaryText = quotes[indexPath.row].quoteDescription
        quoteTableViewCellContentConfiguration.textProperties.color = ColorRGBConstants.riceWine
        quoteTableViewCellContentConfiguration.secondaryTextProperties.color = ColorRGBConstants.riceWine
        
        quoteTableViewCell.contentConfiguration = quoteTableViewCellContentConfiguration

        return quoteTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        self.performSegue(withIdentifier: "goToQuoteDetail", sender: self)
    }

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let safeBookName = quoteBookName else {return}
        let destinationVC = segue.destination as? AddQuoteViewController
        destinationVC?.bookId = bookId
        destinationVC?.quiteBookName = safeBookName
        let destinationDetailVC = segue.destination as? QuotesDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let safeQuoteId = quotes[indexPath.row].id else {return}
            destinationDetailVC?.quoteDocId = safeQuoteId
            destinationDetailVC?.bookDocId = bookId
            destinationDetailVC?.quoteTableView = tableView
            destinationDetailVC?.quoteTitle = quotes[indexPath.row].quoteTitle
            destinationDetailVC?.quoteBookName = quotes[indexPath.row].quoteBookName
            destinationDetailVC?.quoteDescription = quotes[indexPath.row].quoteDescription
            guard let safeQuoteId = quotes[indexPath.row].id else {return}
            destinationDetailVC?.quoteId = safeQuoteId
        }
       
       
    }
    

    @IBAction func addQuoteButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToAddQuote", sender: self)
    }
    
}
