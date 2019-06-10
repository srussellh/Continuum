//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var post: Post? {
        didSet{
            loadViewIfNeeded()
            updateView()
        }
    }
    
    func updateView(){
        guard let post = post, let photo = post.photo else {return}
        photoImageView.image = photo
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func commentButtonTapped(_ sender: Any) {
        let commentBox = UIAlertController(title: "Comment", message: nil, preferredStyle: .alert)
        commentBox.addTextField { (textField) in
            textField.placeholder = "What would you like to say..."
        }
        let comment = UIAlertAction(title: "Comment", style: .default) { (_) in
            guard let commentText = commentBox.textFields?.first?.text, commentBox.textFields?.first?.text != "", let post = self.post else {return}
            PostController.shared.addComment(text: commentText, post: post, completion: { (comment) in
                
            })
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        commentBox.addAction(comment)
        commentBox.addAction(cancel)
        
        self.present(commentBox,animated: true,completion: nil)
        
    }
    @IBAction func sharedButtonTapped(_ sender: Any) {
        guard let post = post else {return}
        presentShareControllerFor(post: post)
    }
    @IBAction func followPostButtonPressed(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let post = post else {return 0}
        return post.comments.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)

        guard let post = post else {return UITableViewCell()}
        let comment = post.comments[indexPath.row]
        cell.textLabel?.text = comment.text
        //check dateformater
        cell.detailTextLabel?.text = comment.timestamp.description
        

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let post = post else {return}
            post.comments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func presentShareControllerFor(post: Post) {
        guard let photo = post.photo else { return }
        let shareController = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        present(shareController, animated: true)
    }

}
