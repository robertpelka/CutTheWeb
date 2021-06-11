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
        for child in sceneChildren {
            guard let name = child.name else { continue }
            switch name {
            case "web":
                createWeb(from: child)
                child.removeFromParent()
            case "spider":
                createSpider(from: child)
                child.removeFromParent()
            default:
                continue
            }
        }
        connectWebs()
    }
    
    func createWeb(from node: SKNode) {
        let web = Web(at: node.position)
        webs.append(web)
        addChild(web)
    }
    
    func createSpider(from node: SKNode) {
        spider = SKSpriteNode(imageNamed: "spider")
        spider.physicsBody = SKPhysicsBody(rectangleOf: spider.size)
        spider.position = node.position
        spider.zPosition = ZPositions.spider
        addChild(spider)
    }
    
    func connectWebs() {
        for web in webs {
            web.createSegments(toReach: spider)
            web.connectSegments()
            web.join(to: spider)
        }
    }
    
}
