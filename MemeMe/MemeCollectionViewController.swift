//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Josh Nerius on 5/25/15.
//  Copyright (c) 2015 Josh Nerius. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var memes: [Meme] = [Meme]()
    
    // Outlet to our collection view
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Based on solution found here: http://stackoverflow.com/a/28327193/704791
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth/3) - 1, height: (screenWidth/3) - 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        memeCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get a copy of the memes array from the AppDelegate
        let obj = UIApplication.sharedApplication().delegate
        let appDelegate = obj as! AppDelegate
        memes = appDelegate.memes
        
        // Reload the collection view
        memeCollectionView.reloadData()
        
        // Disable translucency to prevent table from disappearing under navigation bar
        self.navigationController?.navigationBar.translucent = false
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        cell.memeImage.image = meme.memeImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailVC.meme = self.memes[indexPath.item]
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}