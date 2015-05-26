//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Josh Nerius on 5/25/15.
//  Copyright (c) 2015 Josh Nerius. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var memes: [Meme] = [Meme]()
    
    @IBOutlet weak var memeTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get a copy of the memes array from AppDelegate
        let obj = UIApplication.sharedApplication().delegate
        let appDelegate = obj as! AppDelegate
        self.memes = appDelegate.memes
        
        // Force a reload
        memeTableView.reloadData()
        
        // Disable translucency to prevent table from disappearing under navigation bar
        self.navigationController?.navigationBar.translucent = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.memeLabel.text = "\(meme.topText!) \(meme.bottomText!)"
        cell.memeImage.image = meme.memeImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailVC.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // Delete meme from main data array as well as our local copy
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            memes.removeAtIndex(indexPath.row)
            
            // Delete meme from table view
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}