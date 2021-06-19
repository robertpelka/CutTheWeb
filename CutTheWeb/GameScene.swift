//
//  GameScene.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var webs = [Web]()
    var spider = SKSpriteNode()
    var spiderAnchor = SKShapeNode()
    var score = 0
    var isGameActive = true
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        setupLevel()
    }
    
    func setupLevel() {
        guard let sceneChildren = scene?.children else { return }
        var webNumber = 0
        for child in sceneChildren {
            guard let name = child.name else { continue }
            switch name {
            case "web":
                createWeb(from: child, withNumber: webNumber, special: false)
                child.removeFromParent()
                webNumber += 1
            case "specialWeb":
                createWeb(from: child, withNumber: webNumber, special: true)
                child.removeFromParent()
                webNumber += 1
            case "spider":
                createSpider(from: child)
                child.removeFromParent()
            case "tree":
                createTree(from: child)
                child.removeFromParent()
            case "fly":
                createFly(from: child)
                child.removeFromParent()
            default:
                continue
            }
        }
        connectWebs()
    }
    
    func createWeb(from node: SKNode, withNumber number: Int, special: Bool) {
        let web = Web(at: node.position, withNumber: number, isSpecial: special)
        if !special {
            webs.append(web)            
        }
        addChild(web)
    }
    
    func connectWebs() {
        for web in webs {
            web.createSegments(toReach: spiderAnchor)
            web.joinSegments()
            web.join(to: spiderAnchor)
        }
    }
    
    func createSpider(from node: SKNode) {
        spider = SKSpriteNode(imageNamed: "spider")
        spider.name = NodeNames.spider
        spider.physicsBody = SKPhysicsBody(rectangleOf: spider.size)
        spider.physicsBody?.categoryBitMask = PhysicsCategories.spiderCategory
        spider.physicsBody?.contactTestBitMask = PhysicsCategories.treeCategory | PhysicsCategories.flyCategory
        spider.physicsBody?.collisionBitMask = PhysicsCategories.treeCategory
        spider.physicsBody?.restitution = 0
        spider.position = node.position
        spider.zPosition = ZPositions.spider
        addChild(spider)
        
        spiderAnchor = SKShapeNode(circleOfRadius: 1)
        spiderAnchor.name = NodeNames.spider
        spiderAnchor.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        spiderAnchor.physicsBody?.mass = 0.2
        spiderAnchor.physicsBody?.categoryBitMask = PhysicsCategories.spiderCategory
        spiderAnchor.physicsBody?.contactTestBitMask = PhysicsCategories.specialWebCategory
        spiderAnchor.physicsBody?.collisionBitMask = PhysicsCategories.treeCategory
        spiderAnchor.position = CGPoint(x: spider.frame.midX, y: spider.frame.maxY)
        addChild(spiderAnchor)
        
        let joint = SKPhysicsJointFixed.joint(withBodyA: spider.physicsBody!, bodyB: spiderAnchor.physicsBody!, anchor: spiderAnchor.position)
        physicsWorld.add(joint)
    }
    
    func createTree(from node: SKNode) {
        let tree = SKSpriteNode(imageNamed: "tree")
        tree.setScale(1.8)
        tree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tree.size.width - 120, height: tree.size.height - 120))
        tree.physicsBody?.categoryBitMask = PhysicsCategories.treeCategory
        tree.physicsBody?.restitution = 0
        tree.physicsBody?.friction = 1
        tree.physicsBody?.isDynamic = false
        tree.position = node.position
        tree.zPosition = ZPositions.tree
        addChild(tree)
    }
    
    func createFly(from node: SKNode) {
        let fly = Fly(at: node.position)
        addChild(fly)
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
        if let segmentNameWithoutNumber = segment.name?.prefix(NodeNames.webSegment.count) {
            if segmentNameWithoutNumber == NodeNames.webSegment {
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
    
    override func update(_ currentTime: TimeInterval) {
        checkSpiderPosition()
    }
    
    func checkSpiderPosition() {
        if isGameActive {
            if spider.frame.maxY < frame.minY {
                print("LOSS")
                isGameActive = false
            }
        }
    }
    
}

//MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategories.spiderCategory | PhysicsCategories.treeCategory {
            if isGameActive {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if let tree = (contact.bodyA.node?.name != NodeNames.spider) ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                        if self.spider.position.y > tree.position.y {
                            print("WIN! score: \(self.score)")
                            self.spider.physicsBody?.isDynamic = false
                            self.isGameActive = false
                        }
                    }
                }
            }
        }
        if contactMask == PhysicsCategories.spiderCategory | PhysicsCategories.flyCategory {
            if let fly = (contact.bodyA.node?.name != NodeNames.spider) ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                score += 1
                fly.removeFromParent()
            }
        }
        if contactMask == PhysicsCategories.spiderCategory | PhysicsCategories.specialWebCategory {
            if let specialWeb = (contact.bodyA.node?.name != NodeNames.spider) ? contact.bodyA.node as? Web : contact.bodyB.node as? Web {
                spider.zRotation = 0
                specialWeb.createSegments(toReach: spiderAnchor)
                specialWeb.physicsBody?.categoryBitMask = PhysicsCategories.normalWebCategory
                specialWeb.joinSegments()
                specialWeb.join(to: spiderAnchor)
            }
        }
    }
    
}
