//
//  MenuScene.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 19/06/2021.
//

import SpriteKit

class MenuScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        setupMenu()
    }
    
    func setupMenu() {
        createBackground()
        createLogo()
        createPlayButton()
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.scaleToHeight(of: frame.size)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = ZPositions.background
        addChild(background)
    }
    
    func createLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.scaleToWidth(of: frame.size, multiplier: 0.65)
        logo.position = CGPoint(x: frame.midX, y: (frame.maxY + frame.midY) / 2)
        logo.zPosition = ZPositions.hud
        addChild(logo)
    }
    
    func createPlayButton() {
        let playButton = Button(texture: SKTexture(imageNamed: "playButton"), action: goToLevelMenuScene, number: nil)
        playButton.scaleToWidth(of: frame.size, multiplier: 0.3)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.zPosition = ZPositions.button
        addChild(playButton)
    }
    
    func goToLevelMenuScene(_: Int?) {
        sceneManagerDelegate?.presentLevelMenuScene()
    }
    
}
