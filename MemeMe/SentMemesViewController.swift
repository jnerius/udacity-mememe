//
//  HistoryViewController.swift
//  MemeMe
//
//  Created by Josh Nerius on 5/24/15.
//  Copyright (c) 2015 Josh Nerius. All rights reserved.
//

import UIKit

class SentMemesViewController: UITabBarController {
    var memes: [Meme]!
    
    @IBAction func addPressed(sender: UIBarButtonItem) {
        println("Adding new meme...")
        
        if let editMemeController = storyboard?.instantiateViewControllerWithIdentifier("EditMemeViewController") as? EditMemeViewController {
            presentViewController(editMemeController, animated: true, completion: nil)
        }
    }
}