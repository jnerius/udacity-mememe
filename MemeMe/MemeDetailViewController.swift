//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Josh Nerius on 5/25/15.
//  Copyright (c) 2015 Josh Nerius. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the image to the memed image passed in
        self.memeImageView.image = meme.memeImage
        
        // Re-enable tranlucency
        self.navigationController?.navigationBar.translucent = true
    }
}