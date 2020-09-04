//
//  DashboardViewController.swift
//  layout
//
//  Created by Sinergy on 9/4/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()
        setupView()

        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        
        let buttonCategory = UIButton()
        buttonCategory.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonCategory.widthAnchor.constraint(equalToConstant: 50).isActive = true

        let url = URL(string: "https://development.sinergy-dev.xyz:2096/storage/android/image/category_image/ios.png")!
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    buttonCategory.setBackgroundImage(UIImage(data: data), for: .normal)
                }
            }
        }

        let textButtonCategory = UILabel()
        textButtonCategory.widthAnchor.constraint(equalToConstant: 60).isActive = true
        textButtonCategory.text = "Frontend Development"
        textButtonCategory.font = UIFont.systemFont(ofSize: 9.0)
        textButtonCategory.numberOfLines = 2
        textButtonCategory.textAlignment = .center

        let stackViewButton   = UIStackView()
        stackViewButton.axis  = NSLayoutConstraint.Axis.vertical
        stackViewButton.distribution  = UIStackView.Distribution.equalSpacing
        stackViewButton.alignment = UIStackView.Alignment.center
        stackViewButton.spacing   = 5.0

        stackViewButton.addArrangedSubview(buttonCategory)
        stackViewButton.addArrangedSubview(textButtonCategory)
        stackViewButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(stackViewButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
