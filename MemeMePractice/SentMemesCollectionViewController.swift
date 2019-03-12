//
//  SentMemesCollectionViewController.swift
//  MemeMePractice
//
//  Created by Justin Knight on 3/8/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var sentMemes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up collection view FlowLayout
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (4 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK: Collection View Data Source Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sentMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as!  MemeCollectionViewCell
        let meme = self.sentMemes[(indexPath as NSIndexPath).row]
        cell.memeImageView?.image = meme.memeImage
        if let image = cell.memeImageView.image {
            print("Image was assigned to cell")
        } else { print("NO Image")}
        return cell
    }
    // MARK: Collection View Delegate Methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.sentMemes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    // MARK: Navigation Bar
    @IBAction func addMeme(_ sender: Any) {
        let memeEditController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(memeEditController, animated: true)
    }
}
