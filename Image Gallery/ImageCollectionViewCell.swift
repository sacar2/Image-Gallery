//
//  ImageCollectionViewCell.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-20.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var backgroundImage: UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
}
