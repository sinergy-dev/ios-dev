//
//  IntroScreenController.swift
//  layout
//
//  Created by Rama Agastya on 27/10/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class IntroScreenController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imgScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    var arrImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var aaa = UIImage(named: 'android')
        arrImages.append(UIImage(named:"slide_1")!)
        arrImages.append(UIImage(named:"slide_2")!)
        arrImages.append(UIImage(named:"slide_3")!)
        arrImages.append(UIImage(named:"slide_4")!)

//        let fm = FileManager.default
//        let path = Bundle.main.resourcePath! + "/images"
//        print("cek bundle "+Bundle.main.resourcePath!)
//        print(path)
//        do{
//            let item = try fm.contentsOfDirectory(atPath: path).filter{$0.lowercased().hasSuffix(".png") || $0.lowercased().hasSuffix(".jpg")}
//            print(item)
//            arrImages.removeAll()
//            for imgs in item{
//                print(imgs)
//                arrImages.append(UIImage(named:"images/\(imgs)")!)
//                print(arrImages)
//            }
//        }catch let e{
//            print("error  : \(e)")
//        }
        btnNext.isHidden = true
        btnPrevious.isHidden = true
        btnSkip.roundCorners()
        btnContinue.roundCorners()
        loadScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func loadScrollView() {
        let pageCount = arrImages.count
        imgScrollView.frame = view.bounds
        imgScrollView.delegate = self
        imgScrollView.backgroundColor = UIColor.clear
        imgScrollView.isPagingEnabled = true
        imgScrollView.showsHorizontalScrollIndicator = false
        imgScrollView.showsVerticalScrollIndicator = false
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
        
        for i in (0..<pageCount) {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: i * Int(self.view.frame.size.width) , y: 0 , width:
                Int(self.view.frame.size.width) , height: Int(self.view.frame.size.height/1.2))
            imageView.contentMode = .scaleAspectFit
            imageView.image = arrImages[i]
//            imageView.backgroundColor = UIColor.white
            self.imgScrollView.addSubview(imageView)
        }
        
        let width1 = (Float(arrImages.count) * Float(self.view.frame.size.width))
        imgScrollView.contentSize = CGSize(width: CGFloat(width1), height: self.view.frame.size.height)
        self.pageControl.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)
                
    }
    
    //MARK: -
    // Scrollview Delegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imgScrollView.contentOffset.y = 0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        print(pageNumber)
        if  pageControl.currentPage == arrImages.count - 1{
            btnContinue.setTitle("Finish", for: .normal)
        }
        else{
            btnContinue.setTitle("Continue", for: .normal)
        }
        
        
    }
    
    @objc func pageChanged(sender:AnyObject)
    {
        let xVal = CGFloat(pageControl.currentPage) * imgScrollView.frame.size.width
        imgScrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
        
    }
    
    //change page number on click of button
    func changedPageNumber(){
        let pageNumber = round(imgScrollView.contentOffset.x / imgScrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        print(pageNumber)
        if  pageControl.currentPage == arrImages.count - 1{
            btnContinue.setTitle("Finish", for: .normal)
        }
        else{
            btnContinue.setTitle("Continue", for: .normal)
        }
    }
    
    
    @IBAction func btnPreviousTapped(_ sender: Any) {
        if pageControl.currentPage > 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.imgScrollView.contentOffset.x = self.imgScrollView.contentOffset.x - self.view.frame.size.width
            })
            
           changedPageNumber()
            
        }
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        if pageControl.currentPage < self.arrImages.count - 1 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.imgScrollView.contentOffset.x = self.imgScrollView.contentOffset.x + self.view.frame.size.width
            })
            
            changedPageNumber()
        }
    }
    
    
    @IBAction func btnSkipTapped(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarcontroller") as? UITabBarController
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        if btnContinue.titleLabel?.text == "Finish"{
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarcontroller") as? UITabBarController
            self.navigationController?.pushViewController(loginVC!, animated: true)
            
        }
        else{
            if pageControl.currentPage < self.arrImages.count - 1 {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.imgScrollView.contentOffset.x = self.imgScrollView.contentOffset.x + self.view.frame.size.width
                })
               changedPageNumber()
            }
        }
    }
    
}

extension UIButton {
    func roundCorners() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
}
