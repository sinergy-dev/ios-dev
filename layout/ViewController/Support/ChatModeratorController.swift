//
//  ChatModeratorController.swift
//  layout
//
//  Created by SIP_Sales on 07/12/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import SkeletonView

class ChatModeratorController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource {

    var chatModeratorList:ChatModerator!
    @IBOutlet weak var TVChatModerator: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TVChatModerator.refreshControl = refresher
                    
        TVChatModerator.delegate = self
        TVChatModerator.dataSource = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {

            self.TVChatModerator.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.2))
        })
    }
    
    let refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc
    private func refresh(sender: UIRefreshControl){
        getData {
            self.TVChatModerator.reloadData()
        }
        sender.endRefreshing()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ChatModeratorCell"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.chatModeratorList == nil {
            TVChatModerator.isSkeletonable = true
            TVChatModerator.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .crossDissolve(0.2))
        }
        getData {
            self.TVChatModerator.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.chatModeratorList == nil {
            return 0
        }
        
        if self.chatModeratorList.chat!.count == 0 {
            tableView.setEmptyView_chat(title: "You don't have any chat with moderator.", message: "", messageImage: #imageLiteral(resourceName: "not_found"))
        }
        else {
            tableView.restore_chat()
        }
        
        return self.chatModeratorList.chat!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatModeratorCell") as? ChatModeratorCell else {return UITableViewCell()}
        
        if self.chatModeratorList == nil {
            return cell
        }
        
        cell.jobLabel.text = chatModeratorList.chat![indexPath.row].job.job_name
        
        let sourceFormat = DateFormatter()
        sourceFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let destinationFormat = DateFormatter()
        destinationFormat.dateFormat = "dd MMMM yyyy"

        let dateTime = destinationFormat.string(from: sourceFormat.date(from:self.chatModeratorList.chat![indexPath.row].date_add)!)
        
        cell.dateLabel.text = dateTime
        
        cell.statusLabel.text = chatModeratorList.chat![indexPath.row].status
        
        if let imageURL = URL(string: chatModeratorList.chat![indexPath.row].job_category.category_image_url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.IVChatModerator.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func getData(completed: @escaping() -> ()){
        let url = URL(string: GlobalVariable.urlgetChatModerator)
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "Token")!, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.chatModeratorList = try JSONDecoder().decode(ChatModerator.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error")
                }
            }
        }.resume()
        
    }

}

extension UITableView {
    
    func setEmptyView_chat(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore_chat() {
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        
    }
    
}
