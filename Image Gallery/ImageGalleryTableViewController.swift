//
//  ArtGalleryTableViewController.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController, UITextFieldDelegate {

    var data = ImageGalleryData.shared()
    var currentCell: IndexPath? = nil
    weak var delegate: ImageGalleryTableViewControllerDelegate?

    @IBAction func newImageGallery(_ sender: Any) {
        let imageGallerytitles = data.getImageGalleryTitles()
        let newTitle = "Image Gallery".madeUnique(withRespectTo: imageGallerytitles)
        data.imageGalleries.append( ImageGallery(title: newTitle) )
        deselectCurrentImageGallery()
        let numberOfRowsInSection0 = tableView.numberOfRows(inSection: 0)
        var rowToInsert: IndexPath?
        if numberOfRowsInSection0 == 0{
            rowToInsert = IndexPath(row:  0, section: 0)
        }else if numberOfRowsInSection0 > 0{
            rowToInsert = IndexPath(row:  numberOfRowsInSection0, section: 0)
        }
        if let row = rowToInsert{
            tableView.insertRows(at: [row], with: UITableView.RowAnimation.left)
        }
    }
    
    override func viewDidLoad() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageGalleryTableViewController.makeTextFieldEditable))
        doubleTapGesture.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTapGesture)
        self.title = "Galleries"
    }
    
    @objc func makeTextFieldEditable(recognizer: UIGestureRecognizer){
        if recognizer.state == UIGestureRecognizer.State.ended{
            let locationInView = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: locationInView){
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? GalleryTableViewCell{
                    tappedCell.textField.isEnabled = true
                }
            }
        }
    }
    
    func deselectCurrentImageGallery(){
        currentCell = nil
        data.currentGallery = nil
        delegate?.reloadCollectionViewArea()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch section{
        case 0:
            rows = data.imageGalleries.count
        case 1:
            rows = data.deletedImageGalleries.count
        default:
            rows = 0
        }
        return rows
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
        if data.currentGallery != nil{
            data.imageGalleries[data.currentGallery!].title = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryTableViewCell
        switch indexPath.section{
        case 0:
            cell.textField.delegate = self
            cell.textField.isEnabled = false
            cell.name = data.imageGalleries[indexPath.row].title
        default: break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1{
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 1 && data.deletedImageGalleries.count > 0{
            title = "Recently Deleted"
        }
        return title
    }
   
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //handler = UIContextualAction.Handler: The handler block to call in response to the selection of an action
        if indexPath.section == 1{
            let undeleteAction = UIContextualAction(style: .normal, title: "Undelete Action", handler: {(ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
                self.data.undeleteImageGallery(atIndex: indexPath.row)
                tableView.moveRow(at: indexPath, to: NSIndexPath(row: self.data.imageGalleries.count-1, section: 0) as IndexPath)
                if self.currentCell != nil{
                    self.deselectCurrentImageGallery()
                }
                tableView.reloadData()
                success(true)
            })
            return UISwipeActionsConfiguration(actions: [undeleteAction])
        }else{ return nil }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentCell != indexPath{
            let currentcell = tableView.cellForRow(at: indexPath) as? GalleryTableViewCell
            currentcell?.textField.endEditing(true)
        }
        currentCell = indexPath
        if indexPath.section == 0{
            data.currentGallery = indexPath.row
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedGallery"), object: nil)
            self.splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.primaryHidden
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0{
                // Delete the row from the data source
                data.deleteImageGallery(atIndex: indexPath.row)
                tableView.moveRow(at: indexPath, to: NSIndexPath(row: data.deletedImageGalleries.count-1, section: 1) as IndexPath)
            }else if indexPath.section == 1{
                data.permanentlyDeleteImageGallery(atIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.top)
            }
            deselectCurrentImageGallery()
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

protocol ImageGalleryTableViewControllerDelegate: AnyObject {
    func reloadCollectionViewArea()
}
