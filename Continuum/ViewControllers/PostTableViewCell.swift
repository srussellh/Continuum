//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    
    var post: Post? {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        guard let post = post else {print("dumb");return}
        captionLabel.text = post.caption
        photoView.image = post.photo
        numberOfCommentsLabel.text = "\(post.comments.count)"
    }

}
