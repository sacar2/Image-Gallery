//
//  File.swift
//  Image Gallery
//
//  Created by Selin Denise Acar on 2019-10-10.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ImageGallerySplitViewController: UISplitViewController {
    func setPrimaryOverlay() {
        self.preferredDisplayMode = UISplitViewController.DisplayMode.primaryOverlay
    }
    override func viewWillLayoutSubviews() {
        setPrimaryOverlay()
    }
}
