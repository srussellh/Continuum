//
//  PostController.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    static let shared = PostController()
    var posts: [Post] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void){
        
        let comment = Comment(text: text, post: post)
        let commentRecord = CKRecord(comment: comment)
        post.comments.append(comment)
        publicDB.save(commentRecord) { (record, error) in
            if let error = error {
                print("you cant say that \(error.localizedDescription)")
                return
            }
            guard let record = record,
                let comment = Comment(ckRecord: record, post: post) else {completion(nil); return}
            completion(comment)
        }
        
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void){
        let newPost = Post(caption: caption, photo: image)
        let postRecord = CKRecord(post: newPost)
        posts.append(newPost)
        publicDB.save(postRecord) { (record, error) in
            if let error = error {
                print("not saving \(error.localizedDescription)")
                return
            }
            guard let record = record,
                let post = Post(ckRecord:  record) else {completion(nil); return}
            completion(post)
        }
    }
    
    func fetchPosts(completion: @escaping([Post]?) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.postKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("I cant reach that: \(error.localizedDescription)")
            }
            guard let records = records else { completion(nil); return }
            let posts = records.compactMap{ return Post(ckRecord: $0)}
            self.posts = posts
                completion(posts)
        }
    }
//    func fetchComments(for post: Post, completion: @escaping([Comment]?) -> Void){
//        let predicate = NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>)
//        let query = CKQuery(recordType: <#T##CKRecord.RecordType#>, predicate: <#T##NSPredicate#>)
//        publicDB.perform(<#T##query: CKQuery##CKQuery#>, inZoneWith: nil, completionHandler: <#T##([CKRecord]?, Error?) -> Void#>)
//    }
}
