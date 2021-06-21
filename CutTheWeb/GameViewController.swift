//
//  GameViewController.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuScene = MenuScene()
        present(scene: menuScene, width: .resizeFill)
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
