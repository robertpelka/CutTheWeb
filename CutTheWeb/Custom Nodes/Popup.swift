//
//  Popup.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 25/06/2021.
//

import SpriteKit

class Popup: SKNode {
    
    var isLevelCompleted = true
    var numberOfFliesCatched = 0
    var frameSize = CGSize()
    var levelNumber = 0
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    let playWonSound = SKAction.playSoundFileNamed("won", waitForCompletion: false)
    let playLostSound = SKAction.playSoundFileNamed("lost", waitForCompletion: false)
    
    init(forFrame frameSize: CGSize, levelNumber: Int, isLevelCompleted: Bool, numberOfFliesCatched: Int) {
        super.init()
        self.isLevelCompleted = isLevelCompleted
        self.numberOfFliesCatched = numberOfFliesCatched
        self.frameSize = frameSize
        self.levelNumber = levelNumber
        
        setupPopup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPopup() {
        createBackground()
        createPopupText()
        createFliesScore()
        createButtons()
        playSound()
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "popupBackground")
        background.scaleToHeight(of: frameSize)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = ZPositions.hud
        addChild(background)
    }
    
    func createPopupText() {
        let popupText = SKLabelNode(fontNamed: "RammettoOne-Regular")
        popupText.text = isLevelCompleted && numberOfFliesCatched > 0 ? "LEVEL COMPLETED" : "LEVEL FAILED :C"
        popupText.color = UIColor.white
        popupText.fontSize = 64.0
        popupText.scaleToWidth(of: frameSize, multiplier: 0.5)
        popupText.position = CGPoint(x: frame.midX, y: frame.midY + popupText.frame.size.height * 3.5)
        popupText.zPosition = ZPositions.hudElement
        popupText.verticalAlignmentMode = .center
        addChild(popupText)
    }
    
    func createFliesScore() {
        var numberOfFlies = numberOfFliesCatched
        for i in -1...1 {
            var fly = SKSpriteNode(imageNamed: "flyGray")
            if numberOfFlies > 0 && isLevelCompleted {
                fly = SKSpriteNode(imageNamed: "flyGold")
                numberOfFlies -= 1
            }
            fly.scaleToWidth(of: frameSize, multiplier: 0.11)
            let offset = CGFloat(i) * fly.size.width * 1.5
            fly.position = CGPoint(x: frame.midX + offset, y: frame.midY)
            fly.zPosition = ZPositions.hudElement
            addChild(fly)
        }
    }
    
    func createButtons() {
        let buttonImagesNames = ["menuButton", "restartButton", "nextButton"]
        for i in 0...2 {
            let button = Button(texture: SKTexture(imageNamed: buttonImagesNames[i]), action: handleButton, number: i)
            button.scaleToWidth(of: frameSize, multiplier: 0.12)
            let offset = CGFloat(i-1) * button.size.width * 1.5
            button.position = CGPoint(x: frame.midX + offset, y: frame.midY - button.size.height * 1.5)
            button.zPosition = ZPositions.button
            addChild(button)
        }
    }
    
    func handleButton(number: Int?) {
        switch number {
        case 0:
            sceneManagerDelegate?.presentLevelMenuScene()
        case 1:
            sceneManagerDelegate?.presentLevelScene(number: levelNumber)
        case 2:
            sceneManagerDelegate?.presentLevelScene(number: levelNumber+1)
        default:
            return
        }
    }
    
    func playSound() {
        if isLevelCompleted && numberOfFliesCatched > 0 {
            run(playWonSound)
        }
        else {
            run(playLostSound)
        }
    }
    
}
