//
//  HistoryViewController.swift
//  MemeMe
//
//  Created by Josh Nerius on 5/24/15.
//  Copyright (c) 2015 Josh Nerius. All rights reserved.
//

import UIKit

class SentMemesViewController: UITabBarController {
    @IBAction func addPressed(sender: UIBarButtonItem) {
        presentEditVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tranparency on navigation controller
        self.navigationController?.navigationBar.alpha = 0.2
        
        // The first time the view loads, present the Editor
        presentEditVC()
    }
    
    func presentEditVC() {
        if let editMemeController = storyboard?.instantiateViewControllerWithIdentifier("EditMemeViewController") as? EditMemeViewController {
            presentViewController(editMemeController, animated: true, completion: nil)
        }
    }
}