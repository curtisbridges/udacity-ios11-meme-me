//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Curtis Bridges on 7/26/17.
//  Copyright © 2017 Curtis Bridges. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!


    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Actions
    @IBAction func launchCamera(_ sender: UIBarButtonItem) {
    }

    @IBAction func showAlbumPicker(_ sender: UIBarButtonItem) {
    }

    @IBAction func showShareSheet(_ sender: UIBarButtonItem) {
    }

    @IBAction func doCancel(_ sender: UIBarButtonItem) {
    }

}

