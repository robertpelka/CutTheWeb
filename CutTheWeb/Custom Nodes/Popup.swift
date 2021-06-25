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
    
    init(isLevelCompleted: Bool, numberOfFliesCatched: Int, forFrame frameSize: CGSize) {
        super.init()
        self.isLevelCompleted = isLevelCompleted
        self.numberOfFliesCatched = numberOfFliesCatched
        self.frameSize = frameSize
        setupPopup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPopup() {
        let background = SKSpriteNode(imageNamed: "popupBackground")
        background.scaleToHeight(of: frameSize)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = ZPositions.hud
        addChild(background)
        
        let popupText = SKLabelNode(fontNamed: "RammettoOne-Regular")
        popupText.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        popupText.text = isLevelCompleted ? "LEVEL COMPLETED" : "LEVEL FAILED"
        popupText.fontSize = 36.0
        popupText.color = UIColor.white
        popupText.zPosition = ZPositions.hudElement
        popupText.verticalAlignmentMode = .center
        addChild(popupText)
        
        for i in -1...1 {
            var fly = SKSpriteNode(imageNamed: "flyGray")
            if numberOfFliesCatched > 0 && isLevelCompleted {
                fly = SKSpriteNode(imageNamed: "flyGold")
                numberOfFliesCatched -= 1
            }
            let offset = CGFloat(i) * fly.size.width * 1.5
            fly.position = CGPoint(x: frame.midX + offset, y: frame.midY)
            fly.zPosition = ZPositions.hudElement
            addChild(fly)
        }
    }
    
}
