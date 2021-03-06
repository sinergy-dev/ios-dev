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
import Firebase
import FirebaseDatabase

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
    
    var chatSupportFromSegue:SupportList!
    
    let currentUser = Sender(senderId: "self", displayName: "Engineer")
    
    let otherUser = Sender(senderId: "other", displayName: "Moderator")
    
    var message = [MessageType]()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chatSupportFromSegue.status == "Done"{
            messageInputBar.isHidden = true
            
        }
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        loadChat()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loadChat() {
        ref = Database.database().reference()
                
        ref.child("job_support").child(String(chatSupportFromSegue!.id)).observeSingleEvent(of: .value, with: { (snapshot) in
//            print(id_job)
          }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("job_support").child(String(chatSupportFromSegue!.id)).child("chat").observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//            print(postDict["message"]!)

            if (postDict["from"] as! String == "moderator"){
                let message =  Message(sender: self.otherUser,
                messageId: String(postDict["time"] as! Int),
                sentDate: Date().addingTimeInterval(-26400),
                kind: .text(postDict["message"] as! String))
                self.insertNewMessage(message)
            } else {
                let message =  Message(sender: self.currentUser,
                messageId: String(postDict["time"] as! Int),
                sentDate: Date().addingTimeInterval(-26400),
                kind: .text(postDict["message"] as! String))
                self.insertNewMessage(message)
            }
        })
    }
    
    private func insertNewMessage(_ messag: Message) {
        message.append(messag)
        messagesCollectionView.reloadData()

        DispatchQueue.main.async {
          self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor{
        
        return isFromCurrentSender(message: message) ? .carrot : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }

    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//            print(text)
        let locationRef = ref.child("job_support").child(String(chatSupportFromSegue!.id)).child("chat").childByAutoId()
        locationRef.setValue(["from":"engineer","message":text,"time":Int(NSDate().timeIntervalSince1970)])

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
