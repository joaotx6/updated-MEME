//
//  DetailsViewController.swift
//  1memeAppLaunchIMG
//
//  Created by Joao Teixeira on 03/03/2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var imgView: UIImageView!
    var memedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    func loadImage() {
        self.imgView.image = memedImage
    }
}
