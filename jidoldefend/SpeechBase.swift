import SpriteKit

class SpeechBase : SKSpriteNode {
 
    enum ZCtrl: CGFloat {
        case label = 0
    }
    var label: SKLabelNode!;
    func addLabel (text: String) {
        if let l = label {
            label.removeFromParent();
            label = nil;
        }
        label = SKLabelNode(text: text);
        label.fontColor = UIColor.blackColor();
        label.fontSize = 14;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        label.xScale = self.xScale;
        label.yScale = self.yScale;
        label.zPosition = ZCtrl.label.rawValue;
        self.addChild(label);
    }
    
    func remove() {
        label.removeFromParent();
        label = nil;
        self.removeFromParent();
    }
}