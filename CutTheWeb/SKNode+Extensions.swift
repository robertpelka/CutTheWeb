//
//  SKNode+Extensions.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 19/06/2021.
//

import SpriteKit

extension SKNode {

    func scaleToWidth(of size: CGSize, multiplier: CGFloat = 1.0) {
        let scale = size.width / self.frame.size.width * multiplier
        self.setScale(scale)
    }
    
    func scaleToHeight(of size: CGSize, multiplier: CGFloat = 1.0) {
        let scale = size.height / self.frame.size.height * multiplier
        self.setScale(scale)
    }
    
}
