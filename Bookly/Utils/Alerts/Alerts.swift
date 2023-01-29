//
//  Alerts.swift
//  Bookly
//
//  Created by Alper Yorgun on 29.01.2023.
//

import Foundation
import UIKit

struct BooklyAlert{
    
    static func presentAlert(alertTitle : String, alertMessage : String) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        return alert
        
    }
}
