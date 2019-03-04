//
//  ViewController.swift
//  MemeMePractice
//
//  Created by Justin Knight on 2/1/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//
// This App is to demonstrate how to display a user-desired image in an application either through selection of a pre-existing image
// using the imagePickerController activity or by allowing the usre to take a picture
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var centralImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var tabBar: UIToolbar!
    
    // MARK: Set up defualts and globals
    let defualtTextFieldAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    struct memeObject {
        var toptext: String
        var bottomText: String
        var originalImage: UIImage
        var memeImage: UIImage
    }
    var moveScreenForKeyboard = true
    
    //MARK: View Loading/Dissapearing functions
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        setUpTextFields(textField: topTextField, text: "TOP")
        setUpTextFields(textField: bottomTextField, text: "BOTTOM")
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Picking Image Functions
    @IBAction func pickImage(_ sender: Any) {
        // Check to see if albums or camera sent us here
        let buttonItem = sender as! UIBarButtonItem
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if buttonItem.title == "Album" {
            imagePicker.sourceType = .photoLibrary }
        else { imagePicker.sourceType = .camera}
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            centralImage.image = pickedImage
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TextField Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Don't move the screen up for the keyboard if we are not editing the bottom textfield
        moveScreenForKeyboard = bottomTextField.isFirstResponder
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Check to see if the user actually entered anything, if not make sure that the default text is added back
        if textField.text == "" {
            let replacementStr = textField == topTextField ? "TOP" : "BOTTOM"
            textField.text = replacementStr
        }
        
    }
    
    func setUpTextFields(textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
            textField.defaultTextAttributes = [
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -3.0]
           textField.textAlignment = .center
    }
    
    // MARK: Saving, Sharing, and Cancelling
    func generateMemeImage() -> UIImage {
        // remove navigation and tab bar from view before generating meme
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tabBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        return memedImage
        
    }
    
    func save() {
        _ = memeObject(toptext: topTextField.text!, bottomText: bottomTextField.text!, originalImage: centralImage.image!, memeImage: generateMemeImage())
    }
    @IBAction func share(_ sender: Any) {
        let memeImage = generateMemeImage()
        let activityItems: [Any] = [memeImage]
        let activityController = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {activity, success, items, error in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    // Called when user presses cancel
    @IBAction func cancelEditing () {
        centralImage.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
    }
    
    
    
    
    //MARK: Keyboard functions
    @objc func keyboardWillShow(_ notification:Notification) {
        if moveScreenForKeyboard {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide (_ notification:Notification) {
        view.frame.origin.y = 0.0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
}

