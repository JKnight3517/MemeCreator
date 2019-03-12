//
//  MemeTableViewController.swift
//  MemeMePractice
//
//  Created by Justin Knight on 3/8/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    var sentMemes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
    }
    
    // MARK: Table View Data Soure Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sentMemes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //what data does each row contain
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.sentMemes[indexPath.row]
        
        cell.textLabel?.text = meme.toptext
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.memeImage
        
        return cell
    }
    
    
    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.sentMemes?[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    @IBAction func addMeme(_ sender: Any) {
        let memeEditController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(memeEditController, animated: true)
    }
    
}
