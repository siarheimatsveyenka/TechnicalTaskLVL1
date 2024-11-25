//
//  String+Extension.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import UIKit

extension String {
    func heightForText(isBold: Bool = false) -> CGFloat {
        let font: UIFont = isBold
        ? .systemFont(ofSize: 15, weight: .bold)
        : .systemFont(ofSize: 15)
        
        let textAttributes = [NSAttributedString.Key.font: font]
        let textSize = self.size(withAttributes: textAttributes)
        return textSize.height
    }
    
    func widthForText() -> CGFloat {
        let font: UIFont = .systemFont(ofSize: 15)
        let textAttributes = [NSAttributedString.Key.font: font]
        let textSize = self.size(withAttributes: textAttributes)
        return textSize.width
    }
}
