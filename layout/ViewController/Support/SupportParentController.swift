//
//  SupportParentController.swift
//  layout
//
//  Created by SIP_Sales on 07/12/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit
import CarbonKit

class SupportParentController: UIViewController, CarbonTabSwipeNavigationDelegate {
        
    var controllernames = ["Support", "Moderator"]
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()

        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: controllernames, delegate: self)
        
        carbonTabSwipeNavigation.setTabBarHeight(50)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.orange)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black)
        carbonTabSwipeNavigation.setSelectedColor(UIColor.orange)
        
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 2, forSegmentAt: 1)
        
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return
            UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "SupportController")
        } else {
            return storyboard.instantiateViewController(withIdentifier: "ModeratorController")
        }
    }
}
