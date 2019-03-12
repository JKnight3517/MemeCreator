//
//  MemeDetailViewController.swift
//  MemeMePractice
//
//  Created by Justin Knight on 3/8/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import UIKit
// This is VC is called when a user clicks on a cell in either the Sent Memes collection view or table view.
// TODO: Allow cropping - potentially implementing this cocoa Pod: https://cocoapods.org/pods/TOCropViewController
// TODO: Add button to allow users to edit this meme

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeDetailImageView: UIImageView!
    // This view is only ever called when a Meme object is sent to it so we will explicitly unwrap the Meme object here
    var meme:  Meme!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeDetailImageView.image = meme.memeImage
    }
    
    
    
}
