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
    
    func addImageToGallery(url: URL, image: UIImage){
        if currentGallery != nil{
            imageGalleries[currentGallery!].images.append((url, image))
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
