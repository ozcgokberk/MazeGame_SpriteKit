
import SpriteKit

class Joystick: SKShapeNode {
    
    var isActive: Bool = false
    
    var radius: CGFloat = 0
    var child: SKShapeNode = SKShapeNode()
    
    var vector: CGVector = CGVector()
    var angle: CGFloat = 0
    var raio: CGFloat = 0
    
    var radius90: CGFloat = 1.57079633
    
    override init() {
        super.init()
    }
    
    convenience init(radius: CGFloat) {
        self.init()
        self.radius = radius
        createJoystickBase()
        createJoystickBaseMain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     func createJoystickBase() {
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                             size:   CGSize(width: radius * 2, height: radius * 2)),
                           transform: nil)
        self.fillColor = .blue
        self.strokeColor = .red
        self.alpha = 1.0
        self.lineWidth = 1.0
        self.zPosition = 1.0
    }
    
     func createJoystickBaseMain() {
        child = SKShapeNode(circleOfRadius: radius / 2)
        child.fillColor = .yellow
        child.strokeColor = .red
        child.alpha = 1.0
        child.lineWidth = 1.0
        child.zPosition = 2.0
    }
    
    func setNewPosition(withLocation location: CGPoint) {
        self.position = location
        self.child.position = location
    }
    
    func getDist(withLocation location: CGPoint) -> (xDist: CGFloat, yDist: CGFloat) {
        
        vector = CGVector(dx: location.x - self.position.x,
                          dy: location.y - self.position.y)
        angle = atan2(vector.dy, vector.dx)
        raio = self.frame.size.height / 2.0
        
        let xDist: CGFloat = sin(angle - radius90) * raio
        let yDist: CGFloat = cos(angle - radius90) * raio
        
        if (self.frame.contains(location)) {
            self.child.position = location
        } else {
            self.child.position = CGPoint(x: self.position.x - xDist,
                                          y: self.position.y + yDist)
        }
        
        return (xDist: xDist, yDist: yDist)
    }
    
    func coreReturn() {
        let return_: SKAction = SKAction.move(to: self.position, duration: 0.05)
        return_.timingMode = .easeOut
        child.run(return_)
        isActive = false
    }
    
     func getZRotation() -> CGFloat {
        return angle - radius90
    }
    
     func hiden() {
        self.run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
        self.child.run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
    }
    
    func show() {
        self.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5))
        self.child.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5))
    }
}
