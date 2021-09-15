
//  GameScene.swift

import SpriteKit
import AVKit


class GameScene: SKScene,SKPhysicsContactDelegate {
    var gameOver = false
    let player = SKSpriteNode(imageNamed: "ghost")
    var eatableItems = [SKSpriteNode?]()
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    let lblTime = SKLabelNode()
    let lblPoint = SKLabelNode()
    var apples: Int = 0
    var runCount: Int = 0
    var pointCount : Int = 0
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    let themeSound = SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: false)
    let crunchSound = SKAction.playSoundFileNamed("eatApple.wav", waitForCompletion: false)
    let loseSound = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
    let winSound = SKAction.playSoundFileNamed("win.wav", waitForCompletion: false)
    var 🕹️: Joystick = Joystick(radius: 100)
    
    override func didMove(to view: SKView) {
        let size = UIScreen.main.bounds.size
        
        run(themeSound)
        player.name = "player"
        backgroundColor = .white
        🕹️.setNewPosition(withLocation: CGPoint(x: 0, y: -size.height/3))
        addChild(🕹️)
        addChild(🕹️.child)
        🕹️.hiden()
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.position = CGPoint(x: 0, y: 1300)
        player.xScale = 0.5
        player.yScale = 0.5
        addChild(player)
    
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.runCount += 1
            self.updateLabel(runCount: self.runCount)
        }
        lblTime.fontColor = SKColor.black
        lblTime.fontSize = 100
        lblTime.zPosition = 100
        lblTime.horizontalAlignmentMode = .right
        lblTime.verticalAlignmentMode = .top
        lblTime.position = CGPoint(x: 800, y: 1700)
        addChild(lblTime)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x:        self.frame.minX,y:
                                                                self.frame.minY,width: self.frame.size.width, height: self.frame.size.height))
        
        create_food()
        updatePoint()
        
    }
    func updatePoint(){
        lblPoint.fontColor = SKColor.red
        lblPoint.fontSize = 100
        lblPoint.zPosition = 100
        lblPoint.horizontalAlignmentMode = .left
        lblPoint.verticalAlignmentMode = .top
        lblPoint.position = CGPoint(x: -960, y: 1600)
        addChild(lblPoint)
    }
    func updateLabel(runCount: Int) {
        
        
        if (runCount <= 30) {
            self.lblTime.text = "Time Spent: \(runCount)"
        }else if(runCount > 30){
            self.lblTime.text = "You need to hurry up!: \(runCount) "
        }else{
            
        }
        
        
    }
    func create_food(){
        for i in 1...10{
            let food = SKSpriteNode(imageNamed: "elma")
            food.name = "food"
            food.position = CGPoint(x: CGFloat.random(in: -640.0...640.0), y: CGFloat.random(in: -1280...1280.0))
            
            food.size = CGSize(width: 120, height: 120)
            addChild(food)
            eatableItems.append(food)
        }
        apples = eatableItems.count
    }
    
    func checkCollisions(){
        var hitPlayer: [SKSpriteNode] = []
        enumerateChildNodes(withName: "player") { node , _ in
            let player = node as! SKSpriteNode
            for (index, item) in self.eatableItems.enumerated() {
                
                if let foo = item{
                    if player.frame.intersects(foo.frame){
                        self.ghostEatApple(nodeIndex: index)
                        self.pointCount += 10
                        self.lblPoint.text = "Point = \(self.pointCount)"
                        
                    }
                }
            }
            
        }
    }
    func ghostEatApple(nodeIndex: Int){
        eatableItems[nodeIndex]?.removeFromParent()
        eatableItems.remove(at: nodeIndex)
        run(crunchSound)
        apples -= 1
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.contactTestBitMask = player.physicsBody?.collisionBitMask ?? 0
        for touch in touches {
            let location = touch.location(in: self)
            if !🕹️.isActive {
                
                🕹️.setNewPosition(withLocation: CGPoint(x: location.x, y: location.y))
                🕹️.isActive = true
                🕹️.show()
                
            }
        }
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if 🕹️.isActive {
                
                
                let dist = 🕹️.getDist(withLocation: location)
                
                
                player.zRotation = 🕹️.getZRotation()
                
                
                velocityX = dist.xDist / 8
                velocityY = dist.yDist / 8
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if 🕹️.isActive {
            🕹️.coreReturn()
            velocityX = 0
            velocityY = 0
            🕹️.hiden()
        }
    }

    override func update(_ currentTime: CFTimeInterval) {
        
        deltaTime = currentTime - lastTime
        
        if 🕹️.isActive {
            player.position = CGPoint(x: player.position.x - (velocityX), y: player.position.y + (velocityY))
        }
        
        lastTime = currentTime
        checkCollisions()
        if runCount >= 3 && !gameOver{
            gameOver = true
            run(loseSound)
            let gameOverScene = GameOverScene(size: size, won: false)
            let reveal = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene,transition: reveal)
        }
        if apples == 0 && !gameOver{
            gameOver = true
            run(winSound)
            let gameOverScene = GameOverScene(size: size, won: true)
            let reveal = SKTransition.doorway(withDuration: 0.5)
            view?.presentScene(gameOverScene,transition: reveal)
      
        }
        
    }
    
}


