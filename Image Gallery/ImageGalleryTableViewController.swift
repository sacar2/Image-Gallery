//
//  ArtGalleryTableViewController.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {

    var data = ImageGalleryData.shared()
    
    
    @IBAction func newImageGallery(_ sender: Any) {
        let imageGallerytitles = data.getImageGalleryTitles()
        let newTitle = "Image Gallery".madeUnique(withRespectTo: imageGallerytitles)
        data.imageGalleries.append( ImageGallery(title: newTitle) )
        tableView.reloadData()
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        switch indexPath.section{
        case 0:
            cell.textLabel?.text = data.imageGalleries[indexPath.row].title
        case 1:
            cell.textLabel?.text = data.deletedImageGalleries[indexPath.row].title
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
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            data.currentGallery = indexPath.row
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedGallery"), object: nil)
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
