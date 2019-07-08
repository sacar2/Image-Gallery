//
//  UIImageCollectionViewController.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIDropInteractionDelegate, ImageGalleryTableViewControllerDelegate {
    
    var data = ImageGalleryData.shared()
    var imageFetcher: ImageFetcher!
    var newZoomScale: CGFloat?
    var currentItemSize: CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.collectionView!.addInteraction(UIDropInteraction(delegate: self))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGalleryCollectionView), name: NSNotification.Name(rawValue: "selectedGallery"), object: nil)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ImageCollectionViewController.scaleCollectionViewCells))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    func reloadCollectionViewArea() {
        self.collectionView!.reloadData()
    }
    
    @objc func scaleCollectionViewCells(gesture: UIPinchGestureRecognizer){
        if gesture.state == UIPinchGestureRecognizer.State.began{
            gesture.scale = 1.0
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                currentItemSize = flowLayout.itemSize
            }
        }else if gesture.state == UIPinchGestureRecognizer.State.changed{
            newZoomScale = gesture.scale
        }else if gesture.state == UIPinchGestureRecognizer.State.ended{
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: currentItemSize!.width * newZoomScale!, height: currentItemSize!.height * newZoomScale!)
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var newSize = layout?.itemSize
        if let zoom = newZoomScale{
            newSize = CGSize(width: (newSize?.width)! * zoom, height: (newSize?.height)! * zoom)
            newZoomScale = nil
        }
        return newSize!
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
        var urlStore : URL?
        var imageRatio : Double?
        //this fetches the images as a URL and adds it to the data model
        session.loadObjects(ofClass: NSURL.self){nsurls in
            if let url = nsurls.first as? URL{
                DispatchQueue.main.async {[weak self] in
                    urlStore = url
                    if let ratio = imageRatio, let url = urlStore{
                        self?.data.addImageToGallery(withURL: url, withAspectRatio: ratio)
                    }
                    self?.collectionView!.reloadData()
                }
            }
        }
        session.loadObjects(ofClass: UIImage.self){images in
            if let image = images.first as? UIImage{
                //do something with this image that was dropped
                DispatchQueue.main.async {[weak self] in
                    imageRatio = Double(image.size.height) / Double(image.size.width)
                    if let ratio = imageRatio, let url = urlStore{
                        self?.data.addImageToGallery(withURL: url, withAspectRatio: ratio)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

 
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //get the cell that causes the segue and the index path for it
        if let cell = sender as? ImageCollectionViewCell, let indexPath = collectionView.indexPath(for: cell){
             let seguedNavigationController = segue.destination as? ImageViewController
             if let vc = seguedNavigationController, let gallery = data.currentGallery{
                vc.imageURL = data.imageGalleries[gallery].images[indexPath.item].URL
             }
        }
     }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        var itemsInCollection = 0
        if data.currentGallery == nil{
            collectionView.backgroundView = nil
        }else {
            if let currentGallery = data.currentGallery{
                if data.imageGalleries[currentGallery].images.count > 0{
                itemsInCollection = data.imageGalleries[currentGallery].images.count
                }
            }
        }
        return itemsInCollection
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        if data.currentGallery != nil{
            let imageURL = data.imageGalleries[data.currentGallery!].images[indexPath.row].URL
            cell.imageURL = imageURL.imageURL
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let gallery = data.currentGallery{
            var currentGalleryImages = data.imageGalleries[gallery].images
            let itemToMove = currentGalleryImages[sourceIndexPath.item]
            collectionView.performBatchUpdates({
                //update model
                currentGalleryImages.remove(at: sourceIndexPath.item)
                currentGalleryImages.insert(itemToMove, at: destinationIndexPath.item)
                //update collectionview
                collectionView.reloadData()
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
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
