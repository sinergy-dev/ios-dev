//
//  AlertViewController.swift
//  layout
//
//  Created by SIP_Sales on 20/11/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    
    var alertTitle = String()
    
    var alertBody = String()
    
    var actionButtonTitle = String()
    
    var buttonAction: (() -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        titleLabel.text = alertTitle
        progressLabel.text = alertBody
        actionButton.setTitle(actionButtonTitle, for: .normal)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        dismiss(animated: true)
//        print(self.progressLabel.text!)
        buttonAction?()
    }
    
    func getInput() -> String{
        return self.progressLabel.text!
    }
    
    
}
