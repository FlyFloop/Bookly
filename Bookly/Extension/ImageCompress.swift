//
//  ImageCompress.swift
//  Bookly
//
//  Created by Alper Yorgun on 20.01.2023.
//

import Foundation
import UIKit

extension UIImage {

    func compress(maxKb: Double) -> Data? {
        let quality: CGFloat = maxKb / self.sizeAsKb()
        let compressedData: Data? = self.jpegData(compressionQuality: quality)
        return compressedData
    }

    func sizeAsKb() -> Double {
        Double(self.pngData()?.count ?? 0 / 1024)
    }
}

