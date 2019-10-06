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
    struct ThumbImage{
        var URL : URL
        var aspectRatio : Double //aspect ratio is width/height as a double
    }
    
    var images: [ThumbImage]
    
    init(title: String){
        self.title = title
        self.images = []
    }
    
}
