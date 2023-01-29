//
//  User.swift
//  Bookly
//
//  Created by Alper Yorgun on 6.01.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct UserModel :  Codable , Identifiable {
    
    @DocumentID var id : String? = UUID().uuidString
    var userName : String
    var userBio : String
    var email : String
    var friendsCount : Int
    var profilePhoto : String
    private enum CodingKeys :  String, CodingKey {
        case id
        case userName
        case userBio
        case email
        case friendsCount
        case profilePhoto
    }
    
}
