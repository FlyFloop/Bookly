//
//  Quotes.swift
//  Bookly
//
//  Created by Alper Yorgun on 13.01.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Quote : Codable, Identifiable {
    
    @DocumentID var id : String? = UUID().uuidString
    var bookId : String?
    var quoteTitle : String
    var quoteDescription : String
    var quoteBookName : String
}
