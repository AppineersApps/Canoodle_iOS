//
//  Message1.swift
//  MadCollab
//
//  Created by Appineers India on 25/06/20.
//  Copyright © 2020 hb. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import MessageKit
import FirebaseCore
import FirebaseFirestore

struct ChatMessage {
    
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String
    var readStatus: Bool
    
    var dictionary: [String: Any] {
        
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName": senderName,
            "readStatus": readStatus]
    }
}

extension ChatMessage {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Timestamp,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String,
            let readStatus = dictionary["readStatus"] as? Bool
            else {return nil}
        
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName, readStatus: readStatus)
    }
}

extension ChatMessage: MessageType {
    
    var sender: SenderType {
        return Sender(id: senderID, displayName: senderName)
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        let date = Date()
        return created.dateValue()
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    var isRead: Bool {
        return readStatus
    }
}
