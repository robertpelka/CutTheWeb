//
//  Fly.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 16/06/2021.
//

import SpriteKit

class Fly: SKSpriteNode {
    
    let animationFrames: [SKTexture]
    
    init(at position: CGPoint) {
        animationFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: "fly"), withName: "fly")
        super.init(texture: animationFrames[0], color: UIColor.clear, size: animationFrames[0].size())
        self.position = position
        self.zPosition = ZPositions.fly
        createPhysicsBody()
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: animationFrames[0].size().width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategories.flyCategory
        physicsBody?.collisionBitMask = PhysicsCategories.none
    }
    
    func animate() {
        let moveWings = SKAction.animate(with: animationFrames, timePerFrame: 0.02)
        let moveUp = SKAction.moveBy(x: 0, y: 15, duration: 1.0)
        moveUp.timingMode = .easeOut
        let moveDown = SKAction.moveBy(x: 0, y: -15, duration: 1.0)
        moveDown.timingMode = .easeOut
        let moveUpAndDown = SKAction.sequence([moveUp, moveDown])
        run(SKAction.repeatForever(moveWings))
        run(SKAction.repeatForever(moveUpAndDown))
    }
    
}
