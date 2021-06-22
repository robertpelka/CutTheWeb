//
//  LevelMenuScene.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 22/06/2021.
//

import SpriteKit

class LevelMenuScene: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        setupLevelMenu()
    }
    
    func setupLevelMenu() {
        createBackground()
        createButtons()
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.scaleToHeight(of: frame.size)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = ZPositions.background
        addChild(background)
    }
    
    func createButtons() {
        let numberOfRows = 4
        let numberOfColumns = 3
        var levelNumber = 1
        for row in (1...numberOfRows).reversed() {
            for column in 1...numberOfColumns {
                let levelButton = Button(texture: SKTexture(imageNamed: "LevelButton"), action: goToLevelScene, number: levelNumber)
                levelButton.zPosition = ZPositions.button
                levelButton.scaleToWidth(of: frame.size, multiplier: 0.22)
                
                let spaceX = (frame.size.width - CGFloat(numberOfColumns) * levelButton.size.width) / CGFloat(numberOfColumns+1)
                let offsetX = spaceX + levelButton.size.width/2 + (spaceX + levelButton.size.width) * CGFloat(column-1)
                let spaceY = (frame.size.height - (levelButton.size.width/2 + (spaceX + levelButton.size.width) * CGFloat(numberOfRows))) / 2
                let offsetY = spaceY + spaceX + levelButton.size.width/2 + (spaceX + levelButton.size.width) * CGFloat(row-1)
                
                levelButton.position = CGPoint(x: offsetX, y: offsetY)
                addChild(levelButton)
                
                let buttonText = SKLabelNode(fontNamed: "RammettoOne-Regular")
                buttonText.text = String(levelNumber)
                buttonText.fontSize = levelButton.size.height / 2
                buttonText.color = UIColor.white
                buttonText.zPosition = ZPositions.buttonText
                buttonText.verticalAlignmentMode = .center
                levelButton.addChild(buttonText)
                
                levelNumber += 1
            }
        }
    }
    
    func goToLevelScene(number: Int?) {
        if let levelNumber = number {
            sceneManagerDelegate?.presentLevelScene(number: levelNumber)
        }
    }
    
}
