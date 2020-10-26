//
//  ChatViewController.swift
//  layout
//
//  Created by Rama Agastya on 23/10/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    let currentUser = Sender(senderId: "self", displayName: "Engineer")
    
    let otherUser = Sender(senderId: "other", displayName: "Moderator")
    
    var message = [MessageType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        message.append(Message(sender: currentUser,
                               messageId: "1",
                               sentDate: Date().addingTimeInterval(-86400),
                               kind: .text("Hello")))
        
        message.append(Message(sender: otherUser,
                               messageId: "2",
                               sentDate: Date().addingTimeInterval(-70000),
                               kind: .text("Hi")))
        
        message.append(Message(sender: currentUser,
                               messageId: "3",
                               sentDate: Date().addingTimeInterval(-66400),
                               kind: .text("Here is a long reply. Here is a long reply. Here is a long reply. Here is a long reply. Here is a long reply. ")))
        
        message.append(Message(sender: otherUser,
                               messageId: "4",
                               sentDate: Date().addingTimeInterval(-56400),
                               kind: .text("Wow amazing")))
        
        message.append(Message(sender: currentUser,
                               messageId: "5",
                               sentDate: Date().addingTimeInterval(-46400),
                               kind: .text("Hahahahaha")))
        
        message.append(Message(sender: otherUser,
                               messageId: "6",
                               sentDate: Date().addingTimeInterval(-26400),
                               kind: .text("This is the last message.")))
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func insertNewMessage(_ messag: Message) {
        message.append(messag)
        messagesCollectionView.reloadData()

        DispatchQueue.main.async {
          self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print(text)

        let message =  Message(sender: currentUser,
        messageId: "6",
        sentDate: Date().addingTimeInterval(-26400),
        kind: .text(text))
          //messages.append(message)
        insertNewMessage(message)
        //                  save(message)
        
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        message[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return message.count
    }

}
