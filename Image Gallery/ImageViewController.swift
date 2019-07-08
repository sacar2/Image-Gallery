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
    var imageURL: URL?{
        didSet{
            imageView.image = nil
            fetchImage()
        }
    }
    var image: UIImage?{
        didSet{
            imageView.image = image
            imageView.sizeToFit() //resize the imageView to fit the image
            scrollView?.contentSize = imageView.frame.size //reisze the content size of the scrollview to fit the imageView
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self as UIScrollViewDelegate
            scrollView.addSubview(imageView)
            scrollView.isScrollEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchImage(){
        guard let url = imageURL else{ return }
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            //url may have changed because this is an asynchronous call!
            DispatchQueue.main.async { [weak self] in
                if url == self?.imageURL{
                    self?.image = UIImage(data: imageData)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
