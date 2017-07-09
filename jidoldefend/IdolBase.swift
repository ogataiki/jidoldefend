import SpriteKit

class IdolBase : SKSpriteNode {
    
    // 熱中度関連
    var passion: UInt32 = 100;

    // 恐怖度関連
    var fear: UInt32 = 0;
    var isFearAction: Bool = false;

    var moveTargetIndex: UInt32 = 0;
    var isMoving: Bool = false;
    var movingDate: Date = Date();
    var moveNextInterval: Int = 0;
    var moveVector: CGSize = CGSize.zero;
    
    var contactOtakus: [OtakuBase:OtakuBase] = [:];

    // 台詞
    enum SpeechAction: Int {
        case normal = 0, jump, powerful
    }
    enum SpeechBalloon: String {
        case normal = "idol_speech1"
        case powerful = "idol_speech2"
        case rect = "idol_speech3"
    }

    var isQuited: Bool = false;
    
    func isQuit() -> Bool {
        if(fear > passion)
        {
            isQuited = true;
            return true;
        }
        return false;
    }
    
    func runDefaultAction() {
        
        let rot1 = SKAction.rotate(byAngle: CGFloat(Double.pi*0.05), duration:0.05)
        let stay1 = SKAction.wait(forDuration: 0.4);
        let rot2 = SKAction.rotate(byAngle: CGFloat(-(Double.pi*0.05*2)), duration:0.1)
        let stay2 = SKAction.wait(forDuration: 0.4);
        let rot3 = SKAction.rotate(byAngle: CGFloat(Double.pi*0.05), duration:0.05)
        let seq = SKAction.sequence([rot1, stay1, rot2, stay2, rot3]);
        
        self.run(SKAction.repeatForever(seq));
    }
    
    func addFear(_ value: UInt32) {
        fear += value;
    }
    
    func addFearAction() {
        
        if(isFearAction)
        {
            return;
        }
        self.removeAllActions();
        
        isFearAction = true;
        
        self.color = UIColor.red;
        self.colorBlendFactor = 0.7;
        var selfActions: [SKAction] = [];
        for i in 0 ..< 4 {
            selfActions.append(SKAction.fadeAlpha(to: (i%2==0) ? 0.3 : 1.0, duration: 0.05));
        }
        selfActions.append(SKAction.run({ () -> Void in
            self.alpha = 1.0;
            self.color = UIColor.clear;
            self.colorBlendFactor = 0.0;
            self.zRotation = 0;
            self.isFearAction = false;
            self.runDefaultAction();
        }));
        self.run(SKAction.sequence(selfActions));
    }
    
    func addPassion(_ value: UInt32) {
        passion += value;
    }
    
    func addGrowAction() {
        
        self.removeAllActions();
        
        self.color = UIColor.yellow;
        self.colorBlendFactor = 0.7;
        var selfActions: [SKAction] = [];
        for i in 0 ..< 4 {
            selfActions.append(SKAction.fadeAlpha(to: (i%2==0) ? 0.3 : 1.0, duration: 0.05));
        }
        selfActions.append(SKAction.run({ () -> Void in
            self.alpha = 1.0;
            self.color = UIColor.clear;
            self.colorBlendFactor = 0.0;
            self.zRotation = 0;
            self.runDefaultAction();
        }));
        self.run(SKAction.sequence(selfActions));
        
        for _ in 0 ... 10 {
            let line = SKSpriteNode(imageNamed: "sparkline.png");
            line.blendMode = SKBlendMode.add;
            line.color = UIColor.yellow;
            line.colorBlendFactor = 1.0;
            line.xScale = 0.5;
            line.yScale = 0.1;
            line.alpha = 0.0;
            line.zPosition = self.zPosition;
            let pr = CGFloat(1 + (arc4random() % 10)) * 0.1;
            line.position = CGPoint(x: self.position.x - self.size.width*0.5 + self.size.width*pr, y: self.position.y - self.size.height*0.5);
            line.anchorPoint = CGPoint(x: 0.5, y: 0.05);
            if let parent = self.parent {
                parent.addChild(line);
            }
            
            let r = TimeInterval(1 + arc4random() % 5);
            let wait = SKAction.wait(forDuration: r * 0.1);
            
            let disp = SKAction.run({ () -> Void in
                line.alpha = 1.0;
            });
            
            let grow = SKAction.group([
                SKAction.scaleX(to: 0.1, duration: 0.1),
                SKAction.scaleY(to: 2.0, duration: 0.2),
                SKAction.fadeAlpha(to: 0, duration: 0.2)
                ]);
            
            let endLine = SKAction.run { () -> Void in
                line.removeFromParent();
            }
            let actionLine = SKAction.sequence([wait, disp, grow, endLine]);
            line.run(actionLine);
        }
    }

    
    func runSpeech(_ text: String
        , balloon: SpeechBalloon
        , action: SpeechAction
        , frame: Int
        , target: SKScene
        , z: CGFloat
        , back: SKSpriteNode)
    {
        let speech = SpeechBase(imageNamed: balloon.rawValue);
        // 基本はキャラの左上に表示
        let widthoffset: CGFloat = 0.6;
        let heightoffset: CGFloat = 0.5;
        speech.position = CGPoint(x: self.position.x - speech.size.width*widthoffset
            , y: self.position.y + speech.size.height*heightoffset);
        if(speech.position.x - speech.size.width*0.5 < target.frame.origin.x) {
            // 左が見切れる場合は右側に表示
            speech.position.x = self.position.x + speech.size.width*widthoffset;
            speech.xScale = -1.0;
        }
        if(speech.position.y + speech.size.height*0.5 > target.frame.origin.y + back.size.height) {
            // 上が見切れる場合は下側に表示
            speech.position.y = self.position.y - speech.size.height*heightoffset;
            speech.yScale = -1.0;
        }
        speech.zPosition = z;
        speech.addLabel(text);
        target.addChild(speech);
        
        var seqActions: [SKAction] = [];
        switch(action) {
        case SpeechAction.normal:
            break;
        case SpeechAction.jump:
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: 0.1), duration: 0.1))
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: -0.1), duration: 0.1))
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: 0.1), duration: 0.1))
            seqActions.append(SKAction.move(by: CGVector(dx: 0.0, dy: -0.1), duration: 0.1))
        case SpeechAction.powerful:
            let xscale = speech.xScale;
            let yscale = speech.yScale;
            speech.xScale = 0.0;
            speech.yScale = 0.0;
            
            seqActions.append(SKAction.group([SKAction.scaleX(to: xscale*1.2, duration: 0.2)
                , SKAction.scaleY(to: yscale*1.2, duration: 0.2)
                ]))
            seqActions.append(SKAction.group([SKAction.scaleX(to: xscale*0.95, duration: 0.1)
                , SKAction.scaleY(to: yscale*0.95, duration: 0.1)
                ]));
            seqActions.append(SKAction.group([SKAction.scaleX(to: xscale*1.0, duration: 0.1)
                , SKAction.scaleY(to: yscale*1.0, duration: 0.1)
                ]));
        }
        seqActions.append(SKAction.wait(forDuration: 1.0));
        let endfunc = SKAction.run { () -> Void in
            speech.remove();
        }
        seqActions.append(endfunc);
        let seq = SKAction.sequence(seqActions);
        speech.run(seq);
    }
    
    override func removeAllActions() {
        
        if(isFearAction)
        {
            self.alpha = 1.0;
            self.color = UIColor.clear;
            self.colorBlendFactor = 0.0;
            self.zRotation = 0;
            self.isFearAction = false;
        }

        super.removeAllActions();
    }
}
