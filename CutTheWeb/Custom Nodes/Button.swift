//
//  Button.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 19/06/2021.
//

import SpriteKit

class Button: SKSpriteNode {

    var buttonNode: SKSpriteNode
    var action: () -> ()
    
    init(texture: SKTexture, action: @escaping () -> ()) {
        buttonNode = SKSpriteNode(texture: texture)
        self.action = action
        super.init(texture: nil, color: UIColor.clear, size: texture.size())
        isUserInteractionEnabled = true
        addChild(buttonNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonNode.alpha = 0.7
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouchLocation = touches.first?.location(in: self) {
            if buttonNode.contains(firstTouchLocation) {
                buttonNode.alpha = 0.7
            }
            else {
                buttonNode.alpha = 1.0
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouchLocation = touches.first?.location(in: self) {
            if buttonNode.contains(firstTouchLocation) {
                action()
            }
        }
        buttonNode.alpha = 1.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonNode.alpha = 1.0
    }
    
}
