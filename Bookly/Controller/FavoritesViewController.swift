//
//  FavoritesViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 6.01.2023.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoButtonProtocol {
    var infoButtonState: Bool?
    
    
    
    
    
    var infoButtonModel : InfoButtonModel = InfoButtonModel()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTableViewIcon.image == UIImage(systemName: "books.vertical.fill") {
            return coreDataBookArray.count
        }
        else {
            return coreDataQuoteArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookTableViewCell = favoriteTableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        // bookTableViewCell.backgroundColor = .black
        var bookListContentConfiguration = bookTableViewCell.defaultContentConfiguration()
        if selectedTableViewIcon.image == UIImage(systemName: "books.vertical.fill") {

      
            bookListContentConfiguration.text = coreDataBookArray[indexPath.row].bookName
            bookListContentConfiguration.secondaryText = coreDataBookArray[indexPath.row].bookAuthor
            bookListContentConfiguration.textProperties.color = ColorRGBConstants.riceWine
            bookListContentConfiguration.secondaryTextProperties.color = ColorRGBConstants.riceWine
        }
        if selectedTableViewIcon.image == UIImage(systemName: "quote.bubble.fill") {

            
            bookListContentConfiguration.text = coreDataQuoteArray[indexPath.row].quoteTitle
            bookListContentConfiguration.secondaryText = coreDataQuoteArray[indexPath.row].quoteBookName
            bookListContentConfiguration.textProperties.color = ColorRGBConstants.riceWine
            bookListContentConfiguration.secondaryTextProperties.color = ColorRGBConstants.riceWine
            
        }
        bookTableViewCell.contentConfiguration = bookListContentConfiguration
        return bookTableViewCell
    }
    
    
    @IBOutlet weak var selectedTableViewIcon: UIBarButtonItem!
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    
    let bookIcon = UIImage(systemName: "books.vertical.fill")
    let quoteBookIcon = UIImage(systemName: "quote.bubble.fill")
    var isTableViewBook = true
    var titleString = "Favorite Books"
    lazy var coreDataBookArray : [BookCoreData] = []
    lazy var coreDataQuoteArray : [QuoteCoreData] = []

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDatas()
        favoriteTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        configureNavigationBarTitle(title: titleString)
        fetchDatas()
        favoriteTableView.reloadData()
        infoButtonModel.delegate = self
        infoButtonModel.delegate?.infoButtonState = false
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoriteTableView.cellForRow(at: indexPath)?.selectionStyle = .none
        if isTableViewBook {
            self.performSegue(withIdentifier: "favoriteBookToBookDetail", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "favoriteQuoteToQuoteDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let safeInfoButton = infoButtonModel.delegate?.infoButtonState else {return}
        if safeInfoButton {
            let destinationVC = segue.destination as! InfoViewController
            destinationVC.infoButtonModel = infoButtonModel
            
        }
        else if isTableViewBook == true {
            let destinationVC = segue.destination as! BookDetailViewController
            guard let selectedIndex = favoriteTableView.indexPathForSelectedRow else {return}
            guard let safeBookAuthor = coreDataBookArray[selectedIndex.row].bookAuthor else {return}
            guard let safeBookDescription =  coreDataBookArray[selectedIndex.row].bookDescription else {return}
            guard let safeBookName = coreDataBookArray[selectedIndex.row].bookName else {return}
            guard let safeBookId = coreDataBookArray[selectedIndex.row].bookId else {return}
            destinationVC.bookAuthor = safeBookAuthor
            destinationVC.bookBio = safeBookDescription
            destinationVC.bookName = safeBookName
            destinationVC.bookDocID = safeBookId
            destinationVC.bookTableView = favoriteTableView
        }
        else if isTableViewBook == false {
            let destinationVC = segue.destination as! QuotesDetailViewController
            guard let selectedIndex = favoriteTableView.indexPathForSelectedRow else {return}
            guard let safeQuoteTitle = coreDataQuoteArray[selectedIndex.row].quoteTitle else {return}
            guard let safeQuoteBookName = coreDataQuoteArray[selectedIndex.row].quoteBookName else {return}
            guard let safeQuoteDesc = coreDataQuoteArray[selectedIndex.row].quoteDescription else {return}
            guard let safeQuoteId = coreDataQuoteArray[selectedIndex.row].quoteId else {return}
            guard let safeQuoteBookId = coreDataQuoteArray[selectedIndex.row].quoteBookId else {return}
            destinationVC.quoteTitle = safeQuoteTitle
            destinationVC.quoteBookName = safeQuoteBookName
            destinationVC.quoteDescription = safeQuoteDesc
            destinationVC.quoteId = safeQuoteId
            destinationVC.quoteTableView = favoriteTableView
            destinationVC.bookDocId = safeQuoteBookId
            
        }
    }
    
    func fetchDatas() {
        let booksRequest : NSFetchRequest<BookCoreData> = BookCoreData.fetchRequest()
        loadBooks(request: booksRequest)
        let quotesRequest : NSFetchRequest<QuoteCoreData> = QuoteCoreData.fetchRequest()
        loadQuotes(request: quotesRequest)
    }
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    func changeTableView()  {
        isTableViewBook.toggle()
        
        if isTableViewBook {
            titleString = "Favorite Books"
            guard let safeBookIcon = bookIcon else {return}
            selectedTableViewIcon.image = safeBookIcon
       
        }
        else {
            titleString = "Favorite Quotes"
            guard let safeQuoteIcon = quoteBookIcon else {return}
            selectedTableViewIcon.image = safeQuoteIcon
            
        }
        self.navigationItem.title = titleString
        favoriteTableView.reloadData()
    }
    
    
    @IBAction func tableViewBarButtonItemPressed(_ sender: UIBarButtonItem) {
        changeTableView()
    }
    
    @IBAction func infoIconButtonPressed(_ sender: UIBarButtonItem) {
        infoButtonModel.delegate?.infoButtonState?.toggle()
        presentModal()
    }
    
    func presentModal() {
        self.performSegue(withIdentifier: "goToInfo", sender: self)
    }
    func loadBooks(request : NSFetchRequest<BookCoreData>)  {
        do{
            let fetchedData = try context.fetch(request)
            coreDataBookArray = fetchedData
        } catch {
            print("book core data fetch error")
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
