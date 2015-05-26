//
//  ViewController.swift
//  MemeMe
//
//  Created by Josh Nerius on 5/24/15.
//  Copyright (c) 2015 Josh Nerius. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    // Prep text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName:     UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName:            UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName:     -5.0
    ]
    
    // Keep track of whether or not the top/bottom text fields have been cleared yet
    var topCleared = false
    var bottomCleared = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
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
        let memedImage = generateMemedImage()
        self.memedImage = memedImage
        let activityItems = [memedImage]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // Set up completion handler and save meme
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            
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
        
        // Set up initial text inputs
        topText.text = "TOP"
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        
        bottomText.text = "BOTTOM"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .Center
        
        // Initially, the share button should be disabled
        disableShareButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Enable/Disable camera based on device capabilities and subscribe to keyboard notifications
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
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
    
    /*** UITextFieldDelegate Methods ***/
    func textFieldDidBeginEditing(textField: UITextField) {
        // Only clear text if this is the first time. This allows the user to actually
        // use the values "TOP" or "BOTTOM" in their meme if they choose to.
        if (topCleared == false && textField.text == "TOP") {
            textField.text = "";
            topCleared = true;
        } else if (bottomCleared == false && textField.text == "BOTTOM") {
            textField.text = "";
            bottomCleared = true;
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*** Keyboard Functions ***/
    // Hide keyboard when touching anywhere on the screen other than a text field
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Only move frame if bottom text field is first responder
        if (self.bottomText.isFirstResponder()) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Only move frame if bottom text field is first responder
        if (self.bottomText.isFirstResponder()) {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    /*** Utility Functions ***/
    // Function to enable share button
    func enableShareButton() {
        self.shareButton.enabled = true
    }
    
    // Function to disable share button
    func disableShareButton() {
        self.shareButton.enabled = false
    }
    
    // Function to hide UI elements when taking our snapshot
    func hideUI() {
        topBar.hidden = true;
        bottomBar.hidden = true;
    }
    
    // Function to re-enable UI elements after taking snapshot
    func showUI() {
        topBar.hidden = false;
        bottomBar.hidden = false;
    }
    
    // Here's where the magic happens. Generate the Memed image
    func generateMemedImage() -> UIImage {
        hideUI();
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        showUI();
        
        return memedImage
    }
    
    func saveMeme() {
        var meme = Meme(
            topText: topText.text,
            bottomText: bottomText.text,
            originalImage: self.originalImage!,
            memeImage: self.memedImage!
        )
        
        // Save our meme to the AppDelegate memes array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
}

