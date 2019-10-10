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
    var newZoomScale: CGFloat?
    var currentItemSize: CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.addInteraction(UIDropInteraction(delegate: self))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGalleryCollectionView), name: NSNotification.Name(rawValue: "selectedGallery"), object: nil)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ImageCollectionViewController.scaleCollectionViewCells))
        collectionView.addGestureRecognizer(pinchGesture)
        
        let leftbarbuttonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftBarButtonItem = leftbarbuttonItem
    }
    
    @objc func updateGalleryCollectionView(notification: NSNotification){
        self.collectionView!.reloadData()
        if let gallerySelected = data.currentGallery{
            self.title = data.imageGalleries[gallerySelected].title
        }
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
    
    //MARK: ImageGalleryTableViewControllerDelegate Methods
    func reloadCollectionViewArea() {
        self.collectionView!.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var newSize = layout?.itemSize
        var imageRatio: CGFloat = 1.0
        if let currentGallery = data.currentGallery {
            imageRatio = CGFloat(data.imageGalleries[currentGallery].images[indexPath.row].aspectRatio)
        }
        let cellHeight = newSize!.width / imageRatio
        if let zoom = newZoomScale{
            newSize = CGSize(width: (newSize?.width)! * zoom, height: cellHeight * zoom)
            newZoomScale = nil
        }else{
            newSize = CGSize(width: (newSize?.width)!, height: cellHeight)
        }
        print(newSize!)
        return newSize!
    }
    
    //MARK: UIDropInteractionDelegate Methods
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        var urlStore : URL?
        var imageRatio : Double?
        //fetch the images as a URL and add it to the data model
        session.loadObjects(ofClass: NSURL.self){nsurls in
            //print("nsURLs loaded")
            if let url = nsurls.first as? URL{
                //print("item loaded was infact a URL")
                DispatchQueue.main.async {[weak self] in
                    urlStore = url
                    self?.addImageToData(withImageURL: urlStore, withAspectRatio: imageRatio)
                }
            }
        }
        session.loadObjects(ofClass: UIImage.self){images in
            //print("images loaded")
            if let image = images.first as? UIImage{
                //do something with this image that was dropped
                DispatchQueue.main.async {[weak self] in
                    //print("item loaded was infact an image")
                    imageRatio = Double(image.size.width) / Double(image.size.height)
                    self?.addImageToData(withImageURL: urlStore, withAspectRatio: imageRatio)
                }
            }
        }
    }
    
    func addImageToData(withImageURL url: URL?, withAspectRatio ratio: Double?){
        if let aspectRatio = ratio, let imageUrl = url{
            self.data.addImageToGallery(withURL: imageUrl.imageURL, withAspectRatio: aspectRatio)
            if let gallery = self.data.currentGallery{
                let count = self.data.imageGalleries[gallery].images.count
                let newIndex = [IndexPath(item: count - 1, section: 0)]
                self.collectionView!.insertItems(at: newIndex)
                self.collectionView!.reloadItems(at: newIndex)
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
                vc.aspectRatio = data.imageGalleries[gallery].images[indexPath.item].aspectRatio
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
//            var currentGalleryImages = data.imageGalleries[gallery].images
//            let itemToMove = currentGalleryImages[sourceIndexPath.item]
            collectionView.performBatchUpdates({
                print("moved image")
                //update model
                let itemToMove = data.imageGalleries[gallery].images.remove(at: sourceIndexPath.item)
                data.imageGalleries[gallery].images.insert(itemToMove, at: destinationIndexPath.item)
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
