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
            scrollView?.contentSize = imageView.frame.size //resize the content size of the scrollview to fit the imageView
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
            guard let imageData = try? Data(contentsOf: url) else {
                print("NO DATA RETRIEVED")
                return
            }
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
        let scrollViewRatio = scrollWidth / scrollHeight
        if let ratio = aspectRatio{
            let imageViewRatio = CGFloat(ratio)

            if scrollViewRatio >= 1{ //scrollview is landscape

                if scrollViewRatio < imageViewRatio{
                    //if image is wider than the scrollview given the aspect ratio, set the heights the same.
                    print("image is wider than the scrollview given the aspect ratio")
                    height = scrollHeight
                    width = height * imageViewRatio
                }else{
                    //if image is longer than the scrollview given the aspect ratio, set the width the same.
                    print("if image is longer than the scrollview given the aspect ratio, set the width the same.")
                    width = scrollWidth
                    height = width / imageViewRatio
                }
                
            }else{ //scrollview is portrait (ratio <1)
                
                if scrollViewRatio < imageViewRatio{
                    //if image is wider than the scrollview given the aspect ratio, set the widths the same.
                    print("image is wider than the scrollview given the aspect ratio")
                    width = scrollWidth
                    height = width / imageViewRatio
                }else{
                    //if image is lengthier than the scrollview given the aspect ratio, set the heights the same
                    print("image is lengthier than the scrollview given the aspect ratio")
                    height = scrollHeight
                    width = height * imageViewRatio
                }
                
            }
        }
        return (width, height)
    }
}
