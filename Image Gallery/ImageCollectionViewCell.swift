//
//  ImageCollectionViewCell.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-20.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageURL: URL?{
        didSet{
            imageView.image = nil
            if imageView.window != nil{
                fetchImage()
            }
        }
    }
    
    func fetchImage(){
        guard let url = imageURL else { return }
        // if the imageURL isn't nil aynchronolsly on the global userInitiated queue, get the data of the url
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async{
            guard let imageData = try? Data(contentsOf: url) else {
                print("NO DATA RETRIEVED")
                return
            }
            //after the data is retrieved, on the main queue, set the image of the image view with the retrieved imageData
            DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = UIImage(data: imageData)
                    self?.activityIndicator.stopAnimating()
            }
        }
    }
}
