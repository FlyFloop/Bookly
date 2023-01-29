//
//  Books.swift
//  Bookly
//
//  Created by Alper Yorgun on 13.01.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Book : Codable, Identifiable {
    
    @DocumentID var id : String? = UUID().uuidString
    var bookName : String
    var bookAuthor : String
    var bookDescription: String
    var bookAddedDate : String
}
