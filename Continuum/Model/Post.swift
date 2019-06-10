//
//  Post.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/4/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

struct PostConstants {
    static let postKey = "Post"
    static let timestampKey = "timestamp"
    static let captionKey = "caption"
    static let photoKey = "photo"
    static let commentsKey = "comments"
}

class Post {
    
    let recordID: CKRecord.ID
    
    var photoData: Data?
    let timestamp: Date
    let caption:String
    var comments: [Comment]
    var photo: UIImage? {
        get { guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }set{
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(timestamp: Date = Date(), caption: String, comments: [Comment] = [], photo: UIImage, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
        self.recordID = recordID
        self.photo = photo
    }
    convenience init?(ckRecord: CKRecord){
        guard let caption = ckRecord[PostConstants.captionKey] as? String,
        let timestamp = ckRecord[PostConstants.timestampKey] as? Date,
            let imageAsset = ckRecord[PostConstants.photoKey] as? CKAsset,
            let comments = ckRecord[PostConstants.commentsKey] as? Comment else {return nil}
        let photoData = try? Data(contentsOf: imageAsset.fileURL)
        self.init(timestamp: timestamp, caption: caption, comments: [comments], photo: UIImage(data: photoData!) ?? UIImage(), recordID: ckRecord.recordID)
        
    }
}

extension Post: SearchableRecord{
    func matches(searchTerm: String) -> Bool {
        if self.caption.lowercased().contains(searchTerm.lowercased()){
            return true
        }
        for comment in comments{
            if comment.matches(searchTerm: searchTerm){
                return true
            }
        }
        return false
    }
    var imageAsset: CKAsset? {
        get {
            let tempDictionary = NSTemporaryDirectory()
            let tempDictionaryURL = URL(fileURLWithPath: tempDictionary)
            let fileURL = tempDictionaryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
}

extension CKRecord {
    convenience init(post: Post){
        self.init(recordType: PostConstants.postKey, recordID: post.recordID)
        setValue(post.caption, forKey: PostConstants.captionKey)
        setValue(post.timestamp, forKey: PostConstants.timestampKey)
        setValue(post.imageAsset, forKey: PostConstants.photoKey)
    }
}
