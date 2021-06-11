//
//  GameScene.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // HOLDER
        let strandHolder = SKSpriteNode(imageNamed: "strandHolder")
        strandHolder.position = CGPoint(x: frame.midX, y: frame.midY)
        strandHolder.zPosition = 1
        if let strandHolderSize = strandHolder.texture?.size() {
            strandHolder.physicsBody = SKPhysicsBody(circleOfRadius: strandHolderSize.height/2)
            strandHolder.physicsBody?.affectedByGravity = false
            strandHolder.physicsBody?.isDynamic = false
        }
        addChild(strandHolder)
        
        // SEGMENTS
        var strandSegments = [SKNode]()
        let xPosition = frame.midX
        let yPosition = frame.midY
        let numberOfSegments = 20
        for i in 1...numberOfSegments {
            let segment = SKSpriteNode(color: UIColor.white, size: CGSize(width: 6.0, height: 6.0))
            segment.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 6.0, height: 6.0))
            segment.physicsBody?.density = 10
            segment.zPosition = 1
            let offset = segment.size.height * CGFloat(i)
            segment.position = CGPoint(x: xPosition, y: yPosition-offset)
            strandSegments.append(segment)
            addChild(segment)
        }
        
        // JOINING SEGMENTS
        guard  let holderBody = strandHolder.physicsBody, let firstSegmentBody = strandSegments[0].physicsBody else { return }
        let joinPoint = CGPoint(x: strandSegments[0].frame.midX, y: strandSegments[0].frame.maxY)
        let joint = SKPhysicsJointPin.joint(withBodyA: holderBody, bodyB: firstSegmentBody, anchor: joinPoint)
        physicsWorld.add(joint)
        
        for i in 1..<numberOfSegments {
            guard  let previousSegmentBody = strandSegments[i-1].physicsBody,
                   let nextSegmentBody = strandSegments[i].physicsBody else { return }
            let joinPoint = CGPoint(x: strandSegments[i].frame.midX, y: strandSegments[i].frame.maxY)
            let joint = SKPhysicsJointPin.joint(withBodyA: previousSegmentBody, bodyB: nextSegmentBody, anchor: joinPoint)
            physicsWorld.add(joint)
        }
        
        // SPIDER
        let spider = SKSpriteNode(imageNamed: "spider")
        spider.physicsBody = SKPhysicsBody(rectangleOf: spider.size)
        spider.position = CGPoint(x: frame.midX+100, y: frame.midY-160)
        spider.zPosition = 2
        addChild(spider)
        
        
        // JOINING SPIDER
        if let lastSegment = strandSegments.last {
            lastSegment.position = CGPoint(x: spider.position.x, y: spider.position.y + spider.frame.size.height/2)
        }
        
        guard  let spiderBody = spider.physicsBody, let lastSegmentBody = strandSegments.last?.physicsBody else { return }
        let spiderJoinPoint = CGPoint(x: spider.frame.midX, y: spider.frame.maxY)
        let spiderJoint = SKPhysicsJointPin.joint(withBodyA: spiderBody, bodyB: lastSegmentBody, anchor: spiderJoinPoint)
        physicsWorld.add(spiderJoint)
    }
    
}
