//
//  GameViewController.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentLevelMenuScene()
    func presentLevelScene(number: Int)
}

class GameViewController: UIViewController {

    var musicPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
    }
    
    func present(scene: SKScene, width scaleMode: SKSceneScaleMode) {
        if let view = self.view as! SKView? {
            scene.scaleMode = scaleMode
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
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

//MARK: - SceneManagerDelegate

extension GameViewController: SceneManagerDelegate {
    
    func presentMenuScene() {
        let menuScene = MenuScene()
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene, width: .resizeFill)
        playMusic()
    }
    
    func presentLevelMenuScene() {
        let levelMenuScene = LevelMenuScene()
        levelMenuScene.sceneManagerDelegate = self
        present(scene: levelMenuScene, width: .resizeFill)
        playMusic()
    }
    
    func presentLevelScene(number: Int) {
        let sceneName = "Level\(number)"
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene {
            gameScene.sceneManagerDelegate = self
            gameScene.levelNumber = number
            present(scene: gameScene, width: .aspectFill)
            stopMusic()
        }
    }
    
}

//MARK: - AVFoundation

extension GameViewController {
    
    func playMusic() {
        if musicPlayer?.isPlaying != true {
            let musicPath = Bundle.main.path(forResource: "music.wav", ofType:nil)!
            let musicUrl = URL(fileURLWithPath: musicPath)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: musicUrl)
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.play()
            } catch {
                fatalError("Couldn't load a file with music, \(error)")
            }
        }
    }
    
    func stopMusic() {
        musicPlayer?.stop()
    }
    
}
