//
//  ProfileViewController.swift
//  Bookly
//
//  Created by Alper Yorgun on 5.01.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var settingsAndInfoButton: UIButton!
    
    private let cache = NSCache<NSString, UIImage>()
    let firestore = Firestore.firestore()
    let auth = Auth.auth().currentUser?.uid
    let name = ""
    var imageProfile : UIImage = UIImage()
    lazy var isLocale = false
    

    func configureNavigationBarTitle(title : String) {
        self.navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: ColorRGBConstants.riceWine]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocalUserInfo()
        getUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBarTitle(title: "Profile")
        profilePhotoImageView.layer.cornerRadius = CornerRadiusConstants.buttonCornerRadius
        profilePhotoImageView.clipsToBounds = true
        
        
    }
    func getLocalUserInfo() {
        lazy var isUserNameUserDefaults = false
        lazy var isUserBioUserDefaults = false
        lazy var isProfileUserDefaults = false
    
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            print(1)
            nameLabel.text = userName
            isUserNameUserDefaults = true
        }
        if let userBio = UserDefaults.standard.string(forKey: "userBio") {
            print(1)
            bioLabel.text = userBio
            isUserBioUserDefaults = true
        }
        if let profilePhoto = UserDefaults.standard.string(forKey: "profilePhoto") {
            print(1)
            let url = URL(string: profilePhoto)
            guard let safeUrl = url else {return}
            fetchProfileImage(url: safeUrl)
           isProfileUserDefaults = true
        }
        
        if isProfileUserDefaults && isUserBioUserDefaults && isUserNameUserDefaults   {
            isLocale = false
        }
        else{
            isLocale = true
        }
       
        
    }
    func getUser() {
        
      
        
        
        /*
         DispatchQueue.main.async {
             self.nameLabel.text = firestoreDataName
             self.friendsLabel.text = String(firestoreDataFriendsCount)
             self.bioLabel.text = firestoreDataBioLabel
         }
         */
        
        if isLocale {
            guard let userId = auth else {return}
            firestore.collection("users").document(userId).getDocument { documentSnapshot, error in
                if error != nil {
                    print("error")
                }else{
                    //hepsini lokale kaydet
                    guard let doc = documentSnapshot else {return}
                    guard let data = doc.data() else {return}
                    guard let firestoreDataName = data["userName"] as? String else {return}
                    UserDefaults.standard.set(firestoreDataName, forKey: "userName")
                    guard let firestoreDataFriendsCount = data["friendsCount"] as? Int else {return}
                    UserDefaults.standard.set(firestoreDataFriendsCount, forKey: "friendsCount")
                    guard let firestoreDataBioLabel = data["userBio"] as? String else {return}
                    UserDefaults.standard.set(firestoreDataBioLabel, forKey: "userBio")
                    guard let firestoreImageUrl = data["profilePhoto"] as? String else {return}
                    UserDefaults.standard.set(firestoreImageUrl, forKey: "profilePhoto")
                    let url = URL(string: firestoreImageUrl)
                    guard let safeUrl = url else {return}
                    self.fetchProfileImage(url: safeUrl)
                    DispatchQueue.main.async {
                        self.nameLabel.text = firestoreDataName
//                        self.friendsLabel.text = String(firestoreDataFriendsCount)
                        self.bioLabel.text = firestoreDataBioLabel
                    }
                }
            }
        }
    }
    public func fetchProfileImage(url : URL?) {
        //using cache
        if let image = cache.object(forKey: "profileImage"){
            print("using cache")
          
            DispatchQueue.main.async {
                self.profilePhotoImageView.image = image
            }
            return
        }
        guard let safeUrl = url else {return}
        let task = URLSession.shared.dataTask(with: safeUrl) { [weak self] data, urlResponse, error in
            if error != nil {
             
                return
            }
            guard let imageData = data else {return}
            DispatchQueue.main.async {
            //    self.profilePhotoImageView.image = UIImage(data: imageData)
                let fetchedImage = UIImage(data: imageData)
                guard let safeImage = fetchedImage else {return}
                self?.cache.setObject(safeImage, forKey: "profileImage")
                DispatchQueue.main.async {
                    self?.profilePhotoImageView.image = safeImage
                }
            }
        }
        task.resume()
    }
    
    
    

  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    
    
    @IBAction func settingsAndInfoButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSettingsAndInfo", sender: self)
//        self.tabBarController?.view.removeFromSuperview()
//        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
