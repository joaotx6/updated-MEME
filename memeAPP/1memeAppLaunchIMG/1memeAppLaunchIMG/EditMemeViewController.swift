//
//  ViewController.swift
//  1memeAppLaunchIMG
//
//  Created by Joao Teixeira on 11/01/2022.
//

import Foundation
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    //protocols
    
    //text and images
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var pickFromGalleryButton: UIBarButtonItem!
    
    //buttons top bar (navbar)
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //buttons bottom bar (toolbar)
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imgViewer: UIImageView!
    
    //Create a property called memes, and set it to the memes array from the AppDelegate.
    var memes = [Meme]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        setupTextFields(topTextField, text: "TOP")
        setupTextFields(bottomTextField, text: "BOTTOM")
        
    }
    
    //MARK: textfields
    func setupTextFields(_ textField: UITextField, text: String) {
        
        textField.text = String(text)
        textField.defaultTextAttributes = memetextAttributes
        textField.textAlignment = .center
    }
    
    //activates the camera if supported by device
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //move the view up
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    //height of keyboard for moving the view
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    //MARK: textfields attributes
    
    let memetextAttributes: [NSAttributedString.Key: Any] =  [
        
        .strokeColor: UIColor .black,
        .foregroundColor: UIColor .white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.6
    ]
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imgViewer.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    //MARK: TextFields delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Buttons/actions
    
    @IBAction func pickAndImgCamera(_ sender: Any) {
        pickAnImage(.camera)
        shareButton.isEnabled = true
    }
    
    @IBAction func pickandImgLibrary(_ sender: Any) {
        pickAnImage(.photoLibrary)
        shareButton.isEnabled = true
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        //generate a memed image
        let memedImg = generateMemedImage()
        
        //pass the memedImg inside the activityViewController as activity item
        let activityInstance = UIActivityViewController(activityItems: [memedImg], applicationActivities: nil)
        
        activityInstance.completionWithItemsHandler = { _, completed, _, _ in
            
            if completed {
                //save the meme
                self.save()
                activityInstance.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                self.present(activityInstance, animated: true, completion: nil)
            }
        }
        present(activityInstance, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //create a meme
    func save() {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imgViewer.image!, memedImage: generateMemedImage())
        
        //Code for saving to the app delegate's memes array
        //and
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    //func to show and hide bars
    func showAndHideToolbar(isVisible: Bool) {
        toolBar.isHidden = isVisible
        navBar.isHidden = isVisible
    }
    
    //MARK: render view to an image / generate a memed img
    func generateMemedImage() -> UIImage {
        
        //hide toolbar
        showAndHideToolbar(isVisible: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar
        showAndHideToolbar(isVisible: true)
        
        return memedImage
    }
    
}

