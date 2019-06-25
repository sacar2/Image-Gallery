//
//  UIImageCollectionViewController.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class UIImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIDropInteractionDelegate {

    var data = ImageGalleryData.shared()
    var imageFetcher: ImageFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.collectionView!.addInteraction(UIDropInteraction(delegate: self))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGalleryCollectionView), name: NSNotification.Name(rawValue: "selectedGallery"), object: nil)
    }
    
    @objc func updateGalleryCollectionView(notification: NSNotification){
        self.collectionView!.reloadData()
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        //let imagefetcher know i want the data, let it fetch the data, then call the closure.
        
        //this doesnt really fetch the image yet, closure is run after the items are fetched
        imageFetcher = ImageFetcher(){ (url, image) in
            DispatchQueue.main.async{
                self.data.addImageToGallery(url: url, image: image)            
                self.collectionView!.reloadData()
            }
        }
        //this fetches the images as a UIImage and as a URL to load
        session.loadObjects(ofClass: NSURL.self){nsurls in
            if let url = nsurls.first as? URL{
                self.imageFetcher.fetch(url)
            }
        }
        session.loadObjects(ofClass: UIImage.self){images in
            if let image = images.first as? UIImage{
                self.imageFetcher.backup = image
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        var itemsInCollection = 0
        itemsInCollection = data.imageGalleries[data.currentGallery].images.count
        return itemsInCollection
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        let (_, imageForCell) = data.imageGalleries[data.currentGallery].images[indexPath.row]
        cell.imageView.image = imageForCell
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    

}
