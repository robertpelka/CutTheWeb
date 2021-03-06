//
//  Web.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import SpriteKit

class Web: SKSpriteNode {
    
    var segments: [SKSpriteNode] = []
    var webNumber = 0
    var isSpecial = false
    
    init(at position: CGPoint, withNumber: Int, isSpecial: Bool) {
        var holderTexture = SKTexture()
        if isSpecial {
            holderTexture = SKTexture(imageNamed: "specialStrandHolder")
        }
        else {
            holderTexture = SKTexture(imageNamed: "strandHolder")
        }
        super.init(texture: holderTexture, color: UIColor.clear, size: holderTexture.size())
        self.position = position
        self.zPosition = ZPositions.web
        webNumber = withNumber
        self.isSpecial = isSpecial
        createPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody() {
        if let holderSize = self.texture?.size() {
            self.physicsBody = SKPhysicsBody(circleOfRadius: holderSize.height/2)
            if isSpecial {
                physicsBody?.categoryBitMask = PhysicsCategories.specialWebCategory
            }
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.isDynamic = false
        }
    }
    
    func createSegments(toReach spiderAnchor: SKShapeNode) {
        let segmentHeight = 30.0
        let segmentWidth = 6.0
        var distance = calculateDistance(to: spiderAnchor.position)
        if isSpecial {
            distance = self.size.height/2
        }
        let numberOfSegments = Double(distance - 15) / segmentHeight
        let roundedNumberOfSegments = Int(ceil(numberOfSegments))
        let allWholeSegmentsLength = Double(roundedNumberOfSegments - 1) * segmentHeight
        let lastSegmentHeight = Double(distance - 15) - allWholeSegmentsLength
        
        for i in 1...roundedNumberOfSegments {
            let segment = SKSpriteNode(color: UIColor.white, size: CGSize(width: segmentWidth, height: segmentHeight))
            var offset: CGFloat = 0
            if i == roundedNumberOfSegments {
                segment.size.height = CGFloat(lastSegmentHeight)
                segment.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: segmentWidth, height: lastSegmentHeight))
                offset = CGFloat(segmentHeight) * CGFloat(i-1) + (CGFloat(segmentHeight/2) + CGFloat(lastSegmentHeight/2))
            }
            else {
                segment.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: segmentWidth, height: segmentHeight))
                offset = CGFloat(segmentHeight) * CGFloat(i)
            }
            segment.physicsBody?.mass = 0.1
            segment.physicsBody?.collisionBitMask = PhysicsCategories.spiderCategory
            segment.zPosition = ZPositions.web
            segment.name = NodeNames.webSegment + String(webNumber)
            segment.position = CGPoint(x: position.x, y: position.y - offset)
            segments.append(segment)
            spiderAnchor.scene?.addChild(segment)
        }
    }
    
    func calculateDistance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.position.x, 2) + pow(point.y - self.position.y, 2))
    }
    
    func joinSegments() {
        guard  let holderBody = self.physicsBody, let firstSegmentBody = segments[0].physicsBody else { return }
        let joinPoint = CGPoint(x: self.frame.midX, y: self.frame.midY)
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
    
    func join(to spiderAnchor: SKShapeNode) {
        if let lastSegment = segments.last {
            lastSegment.position = CGPoint(x: spiderAnchor.frame.midX, y: spiderAnchor.frame.midY + lastSegment.size.height/2)
        }
        
        guard  let spiderBody = spiderAnchor.physicsBody, let lastSegmentBody = segments.last?.physicsBody else { return }
        let joint = SKPhysicsJointPin.joint(withBodyA: lastSegmentBody, bodyB: spiderBody, anchor: spiderAnchor.position)
        self.scene?.physicsWorld.add(joint)
    }
    
}
