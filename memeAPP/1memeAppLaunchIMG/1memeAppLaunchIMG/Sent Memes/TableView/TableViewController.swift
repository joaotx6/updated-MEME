//
//  TableView.swift
//  1memeAppLaunchIMG
//
//  Created by Joao Teixeira on 03/03/2022.
//

import UIKit

class TableViewController: UITableViewController  {
    
    //Access the code in viewcontroller that edits the meme
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    //property that hols each meme
    var meme: Meme?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        self.navigateToEditor(meme: nil)
        
    }
    
     func sections(in tableview: UITableView) -> Int {
        return 1
    }
    
    func navigateToEditor(meme: Meme?) {
        self.meme = meme
        self.performSegue(withIdentifier: "goToEditor", sender: self)
    }
    
    func navigateToDetails(meme: Meme?) {
        self.meme = meme
        self.performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes!.count    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemesCollectionViewCell")!
        let meme = self.memes![(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(meme.topText) ... \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let meme = memes![indexPath.row]
        self.navigateToDetails(meme: meme)
        
//        let meme = self.storyboard!.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
//        meme.meme = self.memes![(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(meme, animated: true)
    }
    
    
    
}
