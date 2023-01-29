//
//  SettingsAndInfoViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 28.01.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SettingsAndInfoViewController: UIViewController {
    
    let firebaseAuth = Auth.auth()
    let firebaseFirestore = Firestore.firestore()
    
    var totalQuoteBookNumber = 0
    var totalBookNumber = 0
    
    @IBOutlet weak var bookNumberLabel: UILabel!
    
    
    @IBOutlet weak var quoteNumberLabel: UILabel!
    
    var quoteDoc : [QueryDocumentSnapshot] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarTitle(title: "Settings and Info")
        getBookAndQuoteNumber { array in
                self.bookNumberLabel.text = "\(array[0]) books"
                self.quoteNumberLabel.text = "\(array[1]) quotes"
            
        }
    }
    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    
    
    func getBookAndQuoteNumber(handler : @escaping ([Int]) -> Void) {
        var bookNumber = 0
       
        guard let userIDSafe = self.firebaseAuth.currentUser?.uid else {return}
        self.firebaseFirestore.collection("users").document(userIDSafe).collection("books").getDocuments { querySnapshot, error in
            guard let querySnapshotSafe = querySnapshot else {return}
            let docs = querySnapshotSafe.documents
            let number = docs.count
            bookNumber = number
            self.quoteDoc = docs
            self.getQuotes(handler: { quoteCount in
            //    print("quoteCount\(quoteCount)")
                handler([bookNumber,quoteCount])
            }, doc: self.quoteDoc)
           

        }
    }
    
    func getQuotes(handler : @escaping (Int) -> Void, doc : [QueryDocumentSnapshot]) {

        DispatchQueue.main.async {
            doc.forEach { docSnapshot in
                docSnapshot.reference.collection("quotes").getDocuments { snap, error in
                    guard let safeSnap = snap else {return}
                    let safeSnapDocs = safeSnap.documents
                    let number = safeSnapDocs.count
                    self.totalQuoteBookNumber += number
                    handler(self.totalQuoteBookNumber)
                }
            }
        }
    
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    //does not work
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//        if let navigations = self.tabBarController?.viewControllers {
//                    for item in navigations {
//                        if let navigation = item as? UINavigationController {
//                            navigation.popToRootViewController(animated: false)
//                        }
//                    }
//                }
        do{
            try firebaseAuth.signOut()
            
            //clear userdefaults
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        } catch {
            
        }
    }
    
    
    @IBAction func deleteAccountButtonPressed(_ sender: UIButton) {
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
