//
//  JobCategoryAllViewController.swift
//  layout
//
//  Created by Sinergy on 9/4/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class JobCategoryAllViewController: UIViewController {
    
    var jobCategoryListAll:JobCategoryListAll!
    
    let scrollView = UIScrollView()
    let stackViewMain = UIStackView()
    
    let chunk = 4

    override func viewDidLoad() {
        super.viewDidLoad()

        getDataCategory {
            self.setupScrollView()
            self.setupViews()
//            self.setupViews()
        }
    }
    func getDataCategory(completed: @escaping () -> ()){
        let url = "https://sinergy-dev.xyz:2096/dashboard/getJobCategoryAll"
        
        let components = URLComponents(string: url)!
        let request = URLRequest(url: components.url!)
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.jobCategoryListAll = try JSONDecoder().decode(JobCategoryListAll.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("Json End Error")
                }
            }
        }.resume()
    }
    
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .blue
        stackViewMain.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackViewMain)
        
        scrollView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackViewMain.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackViewMain.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        stackViewMain.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 10).isActive = true
        
        stackViewMain.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 5).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: stackViewMain.bottomAnchor,constant: 5).isActive = true
        
        stackViewMain.axis = NSLayoutConstraint.Axis.vertical
        stackViewMain.distribution = UIStackView.Distribution.equalSpacing
        stackViewMain.alignment = UIStackView.Alignment.leading
        stackViewMain.spacing   = 20.0
    }
    
    func setupViews(){
        for (value) in self.jobCategoryListAll.job_category_all {
            let stackViewEach   = UIStackView()
            stackViewEach.axis  = NSLayoutConstraint.Axis.vertical
            stackViewEach.distribution  = UIStackView.Distribution.equalSpacing
            stackViewEach.alignment = UIStackView.Alignment.leading
            stackViewEach.spacing   = 10.0
//            stackViewEach.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
//            stackViewEach.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 10).isActive = true
            
            let textButton = UILabel()
            textButton.text = value.category_main_name
            textButton.font = UIFont.boldSystemFont(ofSize: 20.0)
            textButton.textAlignment = .center
            
            stackViewMain.addArrangedSubview(textButton)
//            stackViewEach.addArrangedSubview(textButton)
            
            let chunkedCategory = value.category.chunked(into: chunk)
            for (index,_ ) in chunkedCategory.enumerated() {
                print(index)
                
                let stackViewButtonHolder = UIStackView()
                stackViewButtonHolder.axis = NSLayoutConstraint.Axis.horizontal
                stackViewButtonHolder.distribution  = UIStackView.Distribution.equalSpacing
                stackViewButtonHolder.alignment = UIStackView.Alignment.leading
                
                stackViewButtonHolder.spacing   = 5.0
                
                for (value) in chunkedCategory[index] {
                    print(value.category_name)
                    let buttonCategory = UIButton()
                    buttonCategory.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    buttonCategory.widthAnchor.constraint(equalToConstant: 50).isActive = true

                    let url = URL(string: value.category_image_url)!
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                buttonCategory.setBackgroundImage(UIImage(data: data), for: .normal)
                            }
                        }
                    }

                    let textButtonCategory = UILabel()
                    textButtonCategory.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    textButtonCategory.text = value.category_name
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
                    stackViewButtonHolder.addArrangedSubview(stackViewButton)
                }
                if (chunk - chunkedCategory[index].count != 0) {
                    for _ in 1...chunk - chunkedCategory[index].count {
                        let viewEmptyHolder = UIView()
                        viewEmptyHolder.widthAnchor.constraint(equalToConstant: 60).isActive = true
                        viewEmptyHolder.heightAnchor.constraint(equalToConstant: 60).isActive = true
                        viewEmptyHolder.translatesAutoresizingMaskIntoConstraints = false
                        stackViewButtonHolder.addArrangedSubview(viewEmptyHolder)
                    }
                }
                stackViewMain.addArrangedSubview(stackViewButtonHolder)
//                stackViewEach.addArrangedSubview(stackViewButtonHolder)
                stackViewButtonHolder.widthAnchor.constraint(equalTo: stackViewMain.widthAnchor).isActive = true
//                stackViewButtonHolder.widthAnchor.constraint(equalTo: stackViewEach.widthAnchor).isActive = true
                
            }
//            stackViewEach.translatesAutoresizingMaskIntoConstraints = false
//            stackViewMain.addArrangedSubview(stackViewEach)
        }
    }
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
