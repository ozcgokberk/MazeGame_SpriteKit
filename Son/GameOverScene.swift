
//  GameScene.swift

import Foundation
import SpriteKit

class GameOverScene: SKScene {
  let won:Bool
  
  init(size: CGSize, won: Bool) {
    self.won = won
    super.init(size: size)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMove(to view: SKView) {
    var background: SKSpriteNode
    if (won) {
      background = SKSpriteNode(imageNamed: "YouWin")
        
    } else {
      background = SKSpriteNode(imageNamed: "YouLose")
        removeAllActions()
    }
    
    background.position =
      CGPoint(x: self.size.width/2, y: self.size.height/2)
      background.size = self.frame.size
    addChild(background)
  }
}

