//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Curtis Bridges on 7/26/17.
//  Copyright © 2017 Curtis Bridges. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    private let initialTopText = "TOP"
    private let initialBottomText = "BOTTOM"

    private let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -1.0]


    // MARK: Outlets

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!


    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        // enable or disable the camera based upon
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        // setup text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = initialTopText
        topTextField.textAlignment = .center

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = initialBottomText
        bottomTextField.textAlignment = .center

        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    private func isUserEditing() -> Bool {
        return topTextField.text != initialTopText ||
                bottomTextField.text != initialBottomText ||
                imageView.image != nil
    }

    // fileprivate so extensions can still access
    fileprivate func handleInterfaceState() {
        cancelButtonItem.isEnabled = isUserEditing()
        shareButtonItem.isEnabled = isUserEditing()
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
        print("show share sheet")
    }

    // reset the UI
    @IBAction func doCancel(_ sender: UIBarButtonItem) {
        topTextField.text = initialTopText
        bottomTextField.text = initialBottomText
        imageView.image = nil
    }
}

// MARK: - Extensions

// MARK: Keyboard related extensions

extension MemeEditorViewController {
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }

    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
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

        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)

        handleInterfaceState()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: Extension UINavigationControllerDelegate

extension MemeEditorViewController: UINavigationControllerDelegate {
    // TODO?
}
