//
//  FloatingActionButton.swift
//  layout
//
//  Created by Rama Agastya on 21/10/20.
//  Copyright © 2020 Rama Agastya. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButton {
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
}
