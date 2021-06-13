//
//  GameScene.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var webs = [Web]()
    var spider = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        spider.position = CGPoint(x: frame.midX, y: frame.midY)
        
        setupLevel()
    }
    
    func setupLevel() {
        guard let sceneChildren = scene?.children else { return }
        var webNumber = 0
        for child in sceneChildren {
            guard let name = child.name else { continue }
            switch name {
            case "web":
                createWeb(from: child, withNumber: webNumber)
                child.removeFromParent()
                webNumber += 1
            case "spider":
                createSpider(from: child)
                child.removeFromParent()
            default:
                continue
            }
        }
        connectWebs()
    }
    
    func createWeb(from node: SKNode, withNumber number: Int) {
        let web = Web(at: node.position, withNumber: number)
        webs.append(web)
        addChild(web)
    }
    
    func connectWebs() {
        for web in webs {
            web.createSegments(toReach: spider)
            web.connectSegments()
            web.join(to: spider)
        }
    }
    
    func createSpider(from node: SKNode) {
        spider = SKSpriteNode(imageNamed: "spider")
        spider.physicsBody = SKPhysicsBody(rectangleOf: spider.size)
        spider.position = node.position
        spider.zPosition = ZPositions.spider
        addChild(spider)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let currentTouchPosition = touch.location(in: self)
            let previousTouchPosition = touch.previousLocation(in: self)
            scene?.physicsWorld.enumerateBodies(alongRayStart: previousTouchPosition, end: currentTouchPosition, using: { (body, _, _, _) in
                self.checkIfWebCut(with: body)
            })
        }
    }
    
    func checkIfWebCut(with body: SKPhysicsBody) {
        guard let segment = body.node else { return }
        if let segmentNameWithoutNumber = segment.name?.prefix(nodeNames.webSegment.count) {
            if segmentNameWithoutNumber == nodeNames.webSegment {
                cutWeb(at: segment)
            }
        }
    }
    
    func cutWeb(at segment: SKNode) {
        segment.removeFromParent()
        enumerateChildNodes(withName: segment.name!) { (node, _) in
            let fadeOut = SKAction.fadeOut(withDuration: 0.8)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut, remove])
            node.run(sequence)
        }
    }
    
}
