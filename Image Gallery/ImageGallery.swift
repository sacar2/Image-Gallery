//
//  ImageGallery.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

struct ImageGallery{
    
    var title: String
    var images: [(NSURL, UIImage)]
    
    init(title: String){
        self.title = title
        self.images = []
    }
    
}
