//
//  ViewController.swift
//  MemeMe
//
//  Created by Josh Nerius on 5/24/15.
//  Copyright (c) 2015 Josh Nerius. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var originalImage: UIImage?
    var memedImage: UIImage?
    let memeTextAttributes = [
        NSStrokeColorAttributeName:     UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName:            UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName:     -5.0
    ]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromLibrary(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        // let memedImage = generateMemedImage()
        let memedImage = self.originalImage!
        self.memedImage = memedImage
        let activityItems = [memedImage]
        //let activityView = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            
            println("In completionWithItemsHandler")
            
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    /*** UIViewController Overrides ***/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topText.text = "TOP"
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        
        bottomText.text = "BOTTOM"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .Center
        
        disableShareButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    /*** UIImagePickerControllerDelegate Methods ***/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.originalImage = image
            self.imageView.image = image
        }
        
        // Enable the share button since we now have an image
        enableShareButton()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func enableShareButton() {
        self.shareButton.enabled = true
    }
    
    func disableShareButton() {
        self.shareButton.enabled = false
    }
    
    func saveMeme() {
        var meme = Meme(
            topText: topText.text,
            bottomText: bottomText.text,
            originalImage: self.originalImage!,
            memeImage: self.memedImage!
        )
    }
}

