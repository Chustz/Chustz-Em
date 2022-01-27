//
//  GameScene.swift
//  Chustz Em
//
//  Created by Thomas Chustz on 1/8/22.
//
import UIKit
import SpriteKit
import GameplayKit

var player = SKSpriteNode()
var projectile = SKSpriteNode()
var enemy = SKSpriteNode()
var star = SKSpriteNode()
var scoreBoard = SKLabelNode()
var mainLabel = SKLabelNode()
var playerSize = CGSize(width: 100, height: 100)
var projectileSize = CGSize(width: 25, height: 25)
var enemySize = CGSize(width: 100, height: 100)
var spawnTime = 0.9
var touchLocation = CGPoint()
var projectileRate = 0.4
var offBlackColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
var white = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)



var isalive = true
var score = 0


enum colliderType: UInt32 {
    case player = 1
    case projectile = 2
    case enemy = 4
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        self.backgroundColor = offBlackColor
        physicsWorld.contactDelegate = self
        if let particles = SKEmitterNode(fileNamed: "stars.sks") {
            particles.position = CGPoint(x: 0, y: 1100)
            particles.zPosition = -2
            particles.advanceSimulationTime(90)
            addChild(particles)
        }
        
       
        
        user()
        scoreTally()
        spawnRate()
        attackRate()
        
    }
  
    
    
    func user() {
        player = SKSpriteNode(imageNamed: "Spike 2.0")
        player.size =  playerSize
        player.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 250)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.contactTestBitMask = colliderType.enemy.rawValue
        player.physicsBody?.categoryBitMask = colliderType.player.rawValue
        player.physicsBody?.collisionBitMask = colliderType.enemy.rawValue
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = false
        player.name = "playerName"
        player.zPosition = 0
        self.addChild(player)
    }
    func reset(){
        isalive = true
        score = 0
    }
    func playerFire() {
        projectile = SKSpriteNode(imageNamed: "missile")
        projectile.size = projectileSize
        projectile.position = CGPoint(x: player.position.x, y: player.position.y + 0.05)
        
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.contactTestBitMask = colliderType.enemy.rawValue

        projectile.physicsBody?.categoryBitMask = colliderType.projectile.rawValue
        projectile.physicsBody?.collisionBitMask = colliderType.enemy.rawValue
        projectile.physicsBody?.allowsRotation = false
        projectile.physicsBody?.isDynamic = true
        projectile.name = "projectileName"
        projectile.zPosition = -1
        
        fire()
        
        self.addChild(projectile)    }
    
    func fire() {
        let yMovement = SKAction.moveTo(y: 2000, duration: 1)
        let endMovement = SKAction.removeFromParent()
        
        projectile.run(SKAction.sequence([yMovement,endMovement]))
    }
    
    func spawn() {
        enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.size =  enemySize
        let xPos = randombetweenNumbers(firstNum: 0, secondNum: frame.width)
        enemy.position = CGPoint(x: xPos - 500, y: self.frame.size.height/2)
        
        
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.contactTestBitMask = colliderType.projectile.rawValue
        enemy.physicsBody?.categoryBitMask = colliderType.enemy.rawValue
        enemy.physicsBody?.collisionBitMask = colliderType.projectile.rawValue
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.isDynamic = true
        enemy.name = "enemyName"
        enemy.zPosition = 0
        enemyPatterns()
            self.addChild(enemy)    }
   
    func randombetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    func enemyPatterns() {
        let pattern = SKAction.moveTo(y: -900, duration: 3)
        let endpattern = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([pattern, endpattern]))
    }
    func Menu() {
        mainLabel = SKLabelNode(fontNamed: "distantFuture")
        mainLabel.fontSize = 70
        mainLabel.fontColor = white
        mainLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 600)
        mainLabel.text = "Chustz Em Up"
        self.addChild(mainLabel)
    }
    func scoreTally() {
        scoreBoard = SKLabelNode(fontNamed: "distantFuture")
        scoreBoard.fontSize = 55
        scoreBoard.fontColor = white
        scoreBoard.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 90)
        scoreBoard.text = "Score: \(score)"
        self.addChild(scoreBoard)
    }
    
    func attackRate() {
        let timer = SKAction.wait(forDuration: projectileRate)
        let frequency = SKAction.run {
            self.playerFire()
        }
        let sequence = SKAction.sequence([timer, frequency])
        self.run(SKAction.repeatForever(sequence))
    }
    
    
    func spawnRate() {
        let wait = SKAction.wait(forDuration: spawnTime)
        let spawn = SKAction.run {
            self.spawn()
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
        
    }
    
    func playerMove() {
        player.position.x = (touchLocation.x)
    }
   
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: player)
            playerMove()
        }
        
    func didBegin( contact: SKPhysicsContact) {
            let firstBody = contact.bodyA
            let secondBody = contact.bodyB
            
        if (firstBody.categoryBitMask == colliderType.enemy.rawValue) && (secondBody.categoryBitMask == colliderType.projectile.rawValue) || (firstBody.categoryBitMask == colliderType.projectile.rawValue) && (secondBody.categoryBitMask == colliderType.enemy.rawValue) {
                //
                enemyFireContact(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
                
            }
            if (firstBody.categoryBitMask == colliderType.enemy.rawValue) && (secondBody.categoryBitMask == colliderType.player.rawValue) || (firstBody.categoryBitMask == colliderType.player.rawValue) && (secondBody.categoryBitMask == colliderType.enemy.rawValue) {
                //
                playerEnemyTouch(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
        }
    }
        func enemyFireContact(contactA: SKSpriteNode, contactB: SKSpriteNode) {
            if contactA.name == "enemyName" && contactB.name == "projectileName" {
                score = score + 1
                let terminate = SKAction.removeFromParent()
                contactA.run(SKAction.sequence([terminate]))
                contactB.removeFromParent()
                capitalGain()
            }
            if contactA.name == "enemyName" && contactB.name == "projectileName" {
                score = score + 1
                let terminate = SKAction.removeFromParent()
                contactA.run(SKAction.sequence([terminate]))
                contactB.removeFromParent()
                capitalGain()
            }
        }
        
            
        func capitalGain() {
                scoreBoard.text = "score: \(score)"
            }
        func playerEnemyTouch(contactA: SKSpriteNode, contactB: SKSpriteNode) {
                
            if contactA.name == "enemyName" && contactB.name == "playerName" {
            isalive = false
            rip()
            }
            if contactA.name == "enemyName" && contactB.name == "playerName" {
            isalive = false
            rip()
            
}
        }
        func rip() {
                ripPlayer()
            mainLabel.fontSize = 70
                mainLabel.text = "GAME OVER"
            reset()
            
        }
        func restartGame() {
            let wait = SKAction.wait(forDuration: 2.0)
            let titleScene = TitleScene(fileNamed: "TitleScene")
            titleScene?.scaleMode = SKSceneScaleMode.aspectFill
            let transistion = SKTransition.doorway(withDuration: 0.5)
            
            let changeScene = SKAction.run {
                self.scene!.view?.presentScene(titleScene!, transition: transistion)
            }
            let sequence = SKAction.sequence([wait, changeScene])
            self.run(SKAction.repeat(sequence, count: 1))
        }}
    func ripPlayer() {
        player.removeFromParent()
    }
    override func update(_ currentTime: TimeInterval) {
        if isalive == false {
            ripPlayer()
        }
    }
    }

