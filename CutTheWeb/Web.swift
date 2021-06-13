//
//  Web.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import UIKit
import SpriteKit

class Web: SKSpriteNode {
    
    var segments: [SKSpriteNode] = []
    var webNumber = 0
    
    init(at position: CGPoint, withNumber: Int) {
        super.init(texture: SKTexture(imageNamed: "strandHolder"), color: UIColor.clear, size: CGSize(width: 30.0, height: 30.0))
        self.position = position
        self.zPosition = ZPositions.web
        webNumber = withNumber
        if let holderSize = self.texture?.size() {
            self.physicsBody = SKPhysicsBody(circleOfRadius: holderSize.height/2)
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.isDynamic = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSegments(toReach spider: SKSpriteNode) {
        let distance = calculateDistance(to: CGPoint(x: spider.frame.midX, y: spider.frame.maxY))
        let segmentHeight = 6.0
        let numberOfSegments = Int(Double(distance - self.size.height/2) / segmentHeight)

        for i in 1...numberOfSegments {
            let segment = SKSpriteNode(color: UIColor.white, size: CGSize(width: segmentHeight, height: segmentHeight))
            segment.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: segmentHeight, height: segmentHeight))
            segment.physicsBody?.density = 10
            segment.zPosition = ZPositions.web
            segment.name = nodeNames.webSegment + String(webNumber)
            let offset = segment.size.height * CGFloat(i)
            segment.position = CGPoint(x: position.x, y: position.y - offset)
            segments.append(segment)
            spider.scene?.addChild(segment)
        }
    }
    
    func calculateDistance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.position.x, 2) + pow(point.y - self.position.y, 2))
    }
    
    func connectSegments() {
        guard  let holderBody = self.physicsBody, let firstSegmentBody = segments[0].physicsBody else { return }
        let joinPoint = CGPoint(x: segments[0].frame.midX, y: segments[0].frame.maxY)
        let joint = SKPhysicsJointPin.joint(withBodyA: holderBody, bodyB: firstSegmentBody, anchor: joinPoint)
        self.scene?.physicsWorld.add(joint)
        
        for i in 1..<segments.count {
            guard  let previousSegmentBody = segments[i-1].physicsBody,
                   let nextSegmentBody = segments[i].physicsBody else { return }
            let joinPoint = CGPoint(x: segments[i].frame.midX, y: segments[i].frame.maxY)
            let joint = SKPhysicsJointPin.joint(withBodyA: previousSegmentBody, bodyB: nextSegmentBody, anchor: joinPoint)
            self.scene?.physicsWorld.add(joint)
        }
    }
    
    func join(to spider: SKSpriteNode) {
        if let lastSegment = segments.last {
            lastSegment.position = CGPoint(x: spider.position.x, y: spider.position.y + spider.frame.size.height/2)
        }
        
        guard  let spiderBody = spider.physicsBody, let lastSegmentBody = segments.last?.physicsBody else { return }
        let joinPoint = CGPoint(x: spider.frame.midX, y: spider.frame.maxY)
        let joint = SKPhysicsJointPin.joint(withBodyA: spiderBody, bodyB: lastSegmentBody, anchor: joinPoint)
        self.scene?.physicsWorld.add(joint)
    }
    
}
