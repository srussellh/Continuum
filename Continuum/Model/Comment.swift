//
//  Comment.swift
//  Continuum
//
//  Created by Bobba Kadush on 6/6/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

struct CommentConstants {
    static let textKey = "text"
    static let timestampKey = "timestamp"
    static let commentKey = "Comment"
    static let postReferenceKey = "postReference"
}

class Comment {
    
    let recordID: CKRecord.ID
    
    let text: String
    let timestamp: Date
    weak var post: Post?
    var postReference: CKRecord.Reference? {
        guard let post = post else {return nil}
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timestamp: Date = Date(), post: Post?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
        self.post = post
    }
    convenience init?(ckRecord: CKRecord, post: Post){
        guard let text = ckRecord[CommentConstants.textKey] as? String,
            let timestamp = ckRecord[CommentConstants.timestampKey] as? Date else {return nil}
        self.init(text: text, timestamp: timestamp, post: post, recordID: ckRecord.recordID)
        
    }
}

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return self.text.lowercased().contains(searchTerm.lowercased())
    }
}

extension CKRecord {
    convenience init(comment: Comment){
    self.init(recordType: CommentConstants.commentKey, recordID: comment.recordID)
        setValue(comment.text, forKey: CommentConstants.textKey)
        setValue(comment.timestamp, forKey: CommentConstants.timestampKey)
        setValue(comment.postReference, forKey: CommentConstants.postReferenceKey)
    }
}
