//
//  ImageGalleryData.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import Foundation

class ImageGalleryData{
    private static var sharedImageGalleryData: ImageGalleryData?
    var imageGalleries: [ImageGallery] = []
    private(set) var deletedImageGalleries: [ImageGallery] = []
    var currentGallery: Int?
    
    private init() {
    }
    
    static func shared() -> ImageGalleryData {
        if sharedImageGalleryData == nil {
            sharedImageGalleryData = ImageGalleryData()
        }
        return sharedImageGalleryData!
    }
    
    func getImageGalleryTitles() -> [String]{
        return imageGalleries.map{$0.title}
    }
}
