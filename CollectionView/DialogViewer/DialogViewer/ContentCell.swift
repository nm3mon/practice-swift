//
//  ContentCell.swift
//  DialogViewer
//
//  Created by Domenico on 25.04.15.
//  Copyright (c) 2015 Domenico Solazzo. All rights reserved.
//

import UIKit

class ContentCell: UICollectionViewCell {
    var label: UILabel!
    var text: String!
    var maxWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: self.contentView.bounds)
        label.opaque = false
        label.backgroundColor =
            UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        /// The defaultFont() method is a type method of the ContentCell class.
        /// It calls the subclass’ override of defaultFont().
        /// A reference is needed to the subclass’s type object, which is given from self.dynamicType
        label.font = self.dynamicType.defaultFont()
        contentView.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func sizeForContentString(s: String,
        forMaxWidth maxWidth: CGFloat) -> CGSize {
            return CGSizeZero
    }
    
    class func defaultFont() -> UIFont {
        // Preferred font for the body text
        return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }

}
