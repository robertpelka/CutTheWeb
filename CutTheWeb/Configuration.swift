//
//  Configuration.swift
//  CutTheWeb
//
//  Created by Robert Pelka on 11/06/2021.
//

import Foundation
import SpriteKit

enum ZPositions {
    static let background: CGFloat = 0
    static let web: CGFloat = 1
    static let tree: CGFloat = 2
    static let fly: CGFloat = 3
    static let spider: CGFloat = 4
    static let hud: CGFloat = 5
    static let hudElement: CGFloat = 6
    static let button: CGFloat = 7
    static let buttonText: CGFloat = 8
}

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let spiderCategory: UInt32 = 0x1
    static let treeCategory: UInt32 = 0x1 << 1
    static let flyCategory: UInt32 = 0x1 << 2
    static let normalWebCategory: UInt32 = 0x1 << 3
    static let specialWebCategory: UInt32 = 0x1 << 4
}

enum NodeNames {
    static let webSegment = "webSegment"
    static let spider = "spider"
}
