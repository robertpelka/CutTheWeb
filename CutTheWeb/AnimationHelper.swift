//
//  AnimationHelper.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 16/06/2021.
//

import SpriteKit

class AnimationHelper {
    
    static func loadTextures(from atlas: SKTextureAtlas, withName textureName: String) -> [SKTexture] {
        var textures = [SKTexture]()
        
        for textureName in atlas.textureNames {
            textures.append(atlas.textureNamed(textureName))
        }
        
        return textures
    }
    
}
