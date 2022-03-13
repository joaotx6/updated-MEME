//
//  SentMemesCollectionViewController.swift
//  1memeAppLaunchIMG
//
//  Created by Joao Teixeira on 01/03/2022.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Properties
    var pickedMeme: Meme?
    
    //Access the code in viewcontroller that edits the meme
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        goToEditor(meme: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //The method collectionView(_:numberOfItemsInSection:) should return the number of memes in that array.
        if let itemsInSection = self.memes {
            return itemsInSection.count
        }
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func goToEditor(meme: Meme?) {
        self.pickedMeme = meme
        self.performSegue(withIdentifier: "goToEditor", sender: self)
    }
    
    func goToDetails(meme: Meme?) {
        self.pickedMeme = meme
        self.performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemesCollectionViewCell", for: indexPath) as! MemesCollectionViewCell
        let memes = self.memes![(indexPath as NSIndexPath).row]
        
        cell.collectionViewCellImage.image = memes.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = self.memes[(indexPath as NSIndexPath).row]
        goToDetails(meme: detailController)
        }
    
    //MARK: added recently
    func editMemeViewController(segue: UIStoryboardSegue) -> ViewController {
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.viewControllers[0] as! ViewController
        return viewController
    }
    
    func detailsViewController(segue: UIStoryboardSegue) -> DetailsViewController {
        let viewController = segue.destination as! DetailsViewController
        return viewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "goToEditor" == segue.identifier{
            let viewController = editMemeViewController(segue: segue)
            viewController.editMeme = self.pickedMeme
        } else if "goToDetails" == segue.identifier {
            let viewController = detailsViewController(segue: segue)
            viewController.memedImage = self.pickedMeme?.memedImage
        }
    }
}
