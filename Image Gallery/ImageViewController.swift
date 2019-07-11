//
//  ImageViewController.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-07-05.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageView = UIImageView()
    var aspectRatio: Double?
    var imageURL: URL?{
        didSet{
            imageView.image = nil
        }
    }
    var image: UIImage?{
        didSet{
            imageView.image = image
            imageView.sizeToFit() //resize the imageView to fit the image
            scrollView?.contentSize = imageView.frame.size //reisze the content size of the scrollview to fit the imageView
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self as UIScrollViewDelegate
            scrollView.addSubview(imageView)
        }
    }
    
    //MARK: VC Life Cycle Methods
    
    override func viewDidAppear(_ animated: Bool) {
        fetchImage()
    }
    
    //MARK: Scrollview Delegate Methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    //MARK: Methods
    private func fetchImage(){
        guard let url = imageURL else{ return }
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            //url may have changed because this is an asynchronous call!
            DispatchQueue.main.async { [weak self] in
                if url == self?.imageURL{
                    let newImageFrame = self?.getFrameForImage()
                    self?.image = UIImage(data: imageData)
                    self?.imageView.frame = newImageFrame!
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func getFrameForImage() -> CGRect{
        let scrollWidth = self.scrollView.frame.width
        let scrollHeight = self.scrollView.frame.height
        let (imageWidth, imageHeight) = getImageDimensions(fromScrollWidth: scrollWidth, scrollHeight: scrollHeight)
        return CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
    }
    
    func getImageDimensions(fromScrollWidth scrollWidth: CGFloat, scrollHeight: CGFloat) -> (CGFloat, CGFloat){
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if scrollWidth < scrollHeight{
            width = scrollWidth
        }else{
            height = scrollHeight
        }
        
        if let ratio = aspectRatio{
            if ratio >= 1, width > 0{
                height = width / CGFloat(ratio)
            }else if height > 0 {
                width = height * CGFloat(ratio)
            }
        }
        return (width, height)
    }
}
