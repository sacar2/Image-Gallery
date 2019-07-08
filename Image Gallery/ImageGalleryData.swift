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
    private(set) var deletedImageGalleries: [ImageGallery] = []
    var imageGalleries: [ImageGallery] = []
    var currentGallery: Int?
    
    static func shared() -> ImageGalleryData {
        if sharedImageGalleryData == nil {
            sharedImageGalleryData = ImageGalleryData()
        }
        return sharedImageGalleryData!
    }
    
    func getImageGalleryTitles() -> [String]{
        var allTitles = imageGalleries.map{$0.title}
        let deletedTitles = deletedImageGalleries.map{$0.title}
        allTitles.append(contentsOf: deletedTitles)
        return allTitles
    }
    
    func addImageToGallery(withURL url: URL, withAspectRatio ratio: Double){
        if let gallery = currentGallery{
            imageGalleries[gallery].images.append(ImageGallery.ThumbImage(URL: url, aspectRatio: ratio))
        }
    }
    
    func deleteImageGallery(atIndex index: Int){
        deletedImageGalleries.append(imageGalleries.remove(at: index))
    }
    
    func undeleteImageGallery(atIndex index: Int){
        imageGalleries.append(deletedImageGalleries.remove(at: index))
    }
    
    func permanentlyDeleteImageGallery(atIndex index: Int){
        deletedImageGalleries.remove(at: index)
    }
}
