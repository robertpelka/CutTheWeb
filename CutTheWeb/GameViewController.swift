//
//  GameViewController.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentLevelMenuScene()
    func presentLevelScene(number: Int)
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
    }
    
    func present(scene: SKScene, width scaleMode: SKSceneScaleMode) {
        if let view = self.view as! SKView? {
            scene.scaleMode = scaleMode
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: SceneManagerDelegate {
    
    func presentMenuScene() {
        let menuScene = MenuScene()
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene, width: .resizeFill)
    }
    
    func presentLevelMenuScene() {
        let levelMenuScene = LevelMenuScene()
        levelMenuScene.sceneManagerDelegate = self
        present(scene: levelMenuScene, width: .resizeFill)
    }
    
    func presentLevelScene(number: Int) {
        let sceneName = "Level\(number)"
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene {
            gameScene.sceneManagerDelegate = self
            gameScene.levelNumber = number
            present(scene: gameScene, width: .aspectFill)
        }
    }
    
}
