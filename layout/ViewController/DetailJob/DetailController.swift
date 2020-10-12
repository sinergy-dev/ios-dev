//
//  DetailController.swift
//  layout
//
//  Created by Rama Agastya on 31/08/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import CarbonKit

@available(iOS 13.0, *)
class DetailController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    var controllernames = ["Applied", "Accepted", "Progress", "Done"]
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: controllernames, delegate: self)
        
        carbonTabSwipeNavigation.setTabBarHeight(50)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.orange)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black)
        carbonTabSwipeNavigation.setSelectedColor(UIColor.orange)
        
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 2)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 3)
        
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return
            UIViewController() }
        if index == 0 {
            print(index)
            return storyboard.instantiateViewController(withIdentifier: "AppliedController")
        } else if index == 1 {
            print(index)
            return storyboard.instantiateViewController(withIdentifier: "AcceptedController")
        } else if index == 2{
            print(index)
            return storyboard.instantiateViewController(withIdentifier: "ProgressController")
        } else {
            print(index)
            return storyboard.instantiateViewController(withIdentifier: "DoneController")
        }
    }
}
