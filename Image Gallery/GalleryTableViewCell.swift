//
//  GalleryTableViewCell.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-26.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    var name: String = ""{
        didSet{
            textField.text = name
        }
    }
    
    //use a textfield and not a text label because it needs to be editable
    @IBOutlet weak var textField: UITextField!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.backgroundColor = UIColor.darkGray
    }

}
