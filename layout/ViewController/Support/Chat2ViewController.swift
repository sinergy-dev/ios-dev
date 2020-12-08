//
//  Chat2ViewController.swift
//  layout
//
//  Created by SIP_Sales on 07/12/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import FirebaseDatabase

struct Sender2: SenderType {
    var senderId: String
    var displayName: String
}

struct Message2: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
class Chat2ViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    var chatModeratorFromSegue:ChatModeratorList!

    let currentUser = Sender2(senderId: "self", displayName: "Engineer")

    let otherUser = Sender2(senderId: "other", displayName: "Moderator")

    var message = [MessageType]()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chatModeratorFromSegue.status == "Close"{
            messageInputBar.isHidden = true
            
        }

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        loadChat()
        print(chatModeratorFromSegue!.id)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loadChat() {
        ref = Database.database().reference()

        ref.child("chat_moderator").child(String(chatModeratorFromSegue!.id)).observeSingleEvent(of: .value, with: { (snapshot) in
          }) { (error) in
            print(error.localizedDescription)
        }

        ref.child("chat_moderator").child(String(chatModeratorFromSegue!.id)).child("chat").observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//            print(postDict["message"]!)

            if (postDict["from"] as! String == "moderator"){
                let message =  Message2(sender: self.otherUser,
                messageId: String(postDict["time"] as! Int),
                sentDate: Date().addingTimeInterval(-26400),
                kind: .text(postDict["message"] as! String))
                self.insertNewMessage(message)
            } else {
                let message =  Message2(sender: self.currentUser,
                messageId: String(postDict["time"] as! Int),
                sentDate: Date().addingTimeInterval(-26400),
                kind: .text(postDict["message"] as! String))
                self.insertNewMessage(message)
            }
        })
    }
    
    private func insertNewMessage(_ messag: Message2) {
        message.append(messag)
        messagesCollectionView.reloadData()

        DispatchQueue.main.async {
          self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        print(text)
        
        let locationRef = ref.child("chat_moderator").child(String(chatModeratorFromSegue!.id)).child("chat").childByAutoId()
                locationRef.setValue(["from":"engineer",
                                      "fromID":String(chatModeratorFromSegue!.id_engineer),
                                      "fromType":"engineer",
                                      "message":text,
                                      "time":Int(NSDate().timeIntervalSince1970)])
        
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
    
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor{
        
        return isFromCurrentSender(message: message) ? .carrot : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
}
