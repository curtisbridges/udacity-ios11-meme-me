//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Curtis Bridges on 7/26/17.
//  Copyright © 2017 Curtis Bridges. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController {

    // fileprivate so extensions can still access
    fileprivate let initialTopText = "TOP"
    fileprivate let initialBottomText = "BOTTOM"

    // an array to hold created memes
    var savedMemes = [Meme]()

    // define attributable text attributes for top and bottom text fields
    private let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "impact", size: 40)!,
        NSStrokeWidthAttributeName: -1.0]


    // MARK: - Outlets

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var bottomToolbar: UIToolbar!

    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!


    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // connect delegate chains
        navigationController?.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self

        topTextField.text = initialTopText
        bottomTextField.text = initialBottomText
    }

    override func viewWillAppear(_ animated: Bool) {
        // enable or disable the camera based upon if it is available or not...
        // (ipads didn't used to have a camera, user might not allow use of camera priv)
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        // setup text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center

        subscribeToKeyboardNotifications()
        handleInterfaceState()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }

    private func isUserEditing() -> Bool {
        // any user editable element has been changed
        return topTextField.text != initialTopText ||
                bottomTextField.text != initialBottomText ||
                imageView.image != nil
    }

    private func isMemeReady() -> Bool {
        // every user editable element has been changed (top and bottom text, image set)
        return topTextField.text != initialTopText &&
            bottomTextField.text != initialBottomText &&
            imageView.image != nil
    }

    // fileprivate so extensions can still access
    fileprivate func handleInterfaceState() {
        cancelButtonItem.isEnabled = isUserEditing()
        shareButtonItem.isEnabled = isMemeReady()
    }

    // generates the image with top and bottom text overlaid
    private func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideInterfaceChrome(true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        hideInterfaceChrome(false)

        return memedImage
    }

    // hides UI elements so the screen can be captured
    private func hideInterfaceChrome(_ isHidden: Bool) {
        navigationController?.isNavigationBarHidden = isHidden
        bottomToolbar.isHidden = isHidden
    }

    // MARK: - Actions

    // launch the camera app to take a new picture.
    @IBAction func launchCamera(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    // show the album picker to choose an existing image
    @IBAction func showAlbumPicker(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    // share this meme using the system share sheet
    @IBAction func showShareSheet(_ sender: UIBarButtonItem) {
        // capture the meme image from screen
        let memedImage = generateMemedImage()

        // create our meme for saving
        if let top = topTextField.text, let bottom = bottomTextField.text {
            let meme = Meme(topText: top, bottomText: bottom, originalImage: imageView.image, memedImage: memedImage)
            savedMemes.append(meme)
        }

        // share it using ActivityViewController
        let activityViewController = UIActivityViewController.init(activityItems:[memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    // reset the UI
    @IBAction func doCancel(_ sender: UIBarButtonItem) {
        // reset text field to initial strings
        topTextField.text = initialTopText
        bottomTextField.text = initialBottomText

        // dismiss keyboard here if it is visible
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()

        // reset imageview to initial state (no image)
        imageView.image = nil

        // update ui elements to their proper state
        handleInterfaceState()
    }

    // allow user to zoom the image (crop)
    @IBAction func handleZoom(_ sender: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }

    // allow the user to pan the image
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: imageView)
        if let view = imageView {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint(x:0,y:0), in: imageView)
    }
}

// MARK: - Extensions

// MARK: Extension Keyboard
extension MemeEditorViewController {
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }

    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0

        handleInterfaceState()
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        // only adjust view if the bottom textfield is being editted
        return bottomTextField.isFirstResponder ? keyboardSize.cgRectValue.height : 0
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

// MARK: Extension UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {

        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = chosenImage
        }

        dismiss(animated:true, completion: nil)

        handleInterfaceState()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Extension UITextFieldDelegate
extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // only clear the text fields if the user hasn't modified them
        if textField == topTextField && topTextField.text == initialTopText {
            return true
        } else if textField == bottomTextField && bottomTextField.text == initialBottomText {
            return true
        } else {
            return false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Extension UINavigationControllerDelegate
extension MemeEditorViewController: UINavigationControllerDelegate {
    // TODO: In future versions, there will be more screens requiring a nav delegate
}
