//
//  TitleScene.swift
//  Chustz Em
//
//  Created by Thomas Chustz on 1/14/22.
//

import Foundation
import SpriteKit

var buttonPlay: UIButton!
var gameTitle: UILabel!
var buzz = SKSpriteNode()

class TitleScene : SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = offBlackColor
        
    }
    func lightyear() {
        buzz = SKSpriteNode(imageNamed: "player")
        buzz.size = CGSize(width: 180, height: 180)
        buzz.position = CGPoint(x: self.frame.minX, y: self.frame.midY)
        self.addChild(buzz)
    }
    func hello() {
        let buttonMargin = CGFloat(50)
        let buttonSize = CGSize(width: 300, height: 180)
        
        buttonPlay = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
        
        }
    
}


