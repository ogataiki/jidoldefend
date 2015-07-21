import SpriteKit

class IdolBase : SKSpriteNode {
    
    // 熱中度関連
    var passion: UInt32 = 1000;

    // 恐怖度関連
    var fear: UInt32 = 0;
    var isFearAction: Bool = false;

    var moveTargetIndex: UInt32 = 0;
    var isMoving: Bool = false;
    var movingDate: NSDate = NSDate();
    var moveNextInterval: Int = 0;
    var moveVector: CGSize = CGSizeZero;
    
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
        let rot1 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
        let stay1 = SKAction.waitForDuration(0.4);
        let rot2 = SKAction.rotateByAngle(CGFloat(-(M_PI*0.05*2)), duration:0.1)
        let stay2 = SKAction.waitForDuration(0.4);
        let rot3 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
        let seq = SKAction.sequence([rot1, stay1, rot2, stay2, rot3]);
        
        self.runAction(SKAction.repeatActionForever(seq));
    }
    
    func addFear(value: UInt32) {
        fear += value;
        addFearAction();
    }
    
    func addFearAction() {
        
        if(isFearAction)
        {
            return;
        }
        isFearAction = true;

        self.color = UIColor.redColor();
        self.colorBlendFactor = 0.7;
        var selfActions: [SKAction] = [];
        for i in 0 ..< 4 {
            selfActions.append(SKAction.fadeAlphaTo((i%2==0) ? 0.3 : 1.0, duration: 0.05));
        }
        selfActions.append(SKAction.runBlock({ () -> Void in
            self.alpha = 1.0;
            self.color = UIColor.clearColor();
            self.colorBlendFactor = 0.0;
            self.isFearAction = false;
        }));
        self.runAction(SKAction.sequence(selfActions));
    }
    
    func runSpeech(text: String
        , balloon: SpeechBalloon
        , action: SpeechAction
        , frame: Int
        , target: SKScene
        , z: CGFloat)
    {
        let speech = SpeechBase(imageNamed: balloon.rawValue);
        // 基本はキャラの左上に表示
        let widthoffset: CGFloat = 0.6;
        let heightoffset: CGFloat = 0.5;
        speech.position = CGPointMake(self.position.x - speech.size.width*widthoffset
            , self.position.y + speech.size.height*heightoffset);
        if(speech.position.x - speech.size.width*0.5 < target.frame.origin.x) {
            // 左が見切れる場合は右側に表示
            speech.position.x = self.position.x + speech.size.width*widthoffset;
            speech.xScale = -1.0;
        }
        if(speech.position.y + speech.size.height*0.5 > target.frame.origin.y + target.size.height) {
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
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, 0.1), duration: 0.1))
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, -0.1), duration: 0.1))
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, 0.1), duration: 0.1))
            seqActions.append(SKAction.moveBy(CGVectorMake(0.0, -0.1), duration: 0.1))
        case SpeechAction.powerful:
            let xscale = speech.xScale;
            let yscale = speech.yScale;
            speech.xScale = 0.0;
            speech.yScale = 0.0;
            
            seqActions.append(SKAction.group([SKAction.scaleXTo(xscale*1.2, duration: 0.2)
                , SKAction.scaleYTo(yscale*1.2, duration: 0.2)
                ]))
            seqActions.append(SKAction.group([SKAction.scaleXTo(xscale*0.95, duration: 0.1)
                , SKAction.scaleYTo(yscale*0.95, duration: 0.1)
                ]));
            seqActions.append(SKAction.group([SKAction.scaleXTo(xscale*1.0, duration: 0.1)
                , SKAction.scaleYTo(yscale*1.0, duration: 0.1)
                ]));
        default:
            break;
        }
        seqActions.append(SKAction.waitForDuration(1.0));
        let endfunc = SKAction.runBlock { () -> Void in
            speech.remove();
        }
        seqActions.append(endfunc);
        let seq = SKAction.sequence(seqActions);
        speech.runAction(seq);
    }
}