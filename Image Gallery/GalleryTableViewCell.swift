//
//  GalleryTableViewCell.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-06-26.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var name: String = ""{
        didSet{
            textField.text = name
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
