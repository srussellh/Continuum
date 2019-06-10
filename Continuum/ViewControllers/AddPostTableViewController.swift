//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.selectImage.titleLabel?.text = ""
        self.image.image = image
    }
    
    
    @IBOutlet weak var captionLabel: UITextField!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var selectImage: UIButton!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    
    
    @IBAction func selectImageTapped(_ sender: UIButton) {
        
        self.imagePicker.present(from: sender)
    
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let caption = captionLabel.text, let image = image.image else {return}
        PostController.shared.createPostWith(image: image, caption: caption) { (post) in
            if let post = post{
                PostController.shared.posts.append(post)
            }
        }
        self.tabBarController?.selectedIndex = 0
//        performSegue(withIdentifier: "toListVC", sender: nil)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    override func viewDidDisappear(_ animated: Bool) {
        selectImage.setTitle("Select Image", for: .normal)
        image.image = nil
        captionLabel.text = ""
    }
    
}
