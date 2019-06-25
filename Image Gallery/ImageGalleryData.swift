//
//  ImageGalleryData.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ImageGalleryData{
    private static var sharedImageGalleryData: ImageGalleryData?
    var imageGalleries: [ImageGallery] = []
    private(set) var deletedImageGalleries: [ImageGallery] = []
    var currentGallery: Int = 0
    
    private init() {
        imageGalleries.append(ImageGallery(title: "Image Gallery"))
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
    
    func addImageToGallery(url: URL, image: UIImage){
        imageGalleries[currentGallery].images.append((url, image))
    }
}
