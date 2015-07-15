import SpriteKit

class GameScene: SKScene {
    
    var isTouch: Bool = false;
    var touchLocation: CGPoint = CGPointMake(0, 0);
    
    var applyforce_last_date: NSDate = NSDate();
    var applyforce_interval: Int = 50;

    let idol_name = "idol";
    enum otaku_name: String {
        case normal = "otaku_normal"
        case core = "otaku_core"
        case bad = "otaku_bad"
    }
    
    enum ZCtrl: CGFloat {
        case touchEffect = 10
        case idol = 0
        case otakuGrowPassion = -1
        case otakuDownPassion = -2
        case otaku = -3
        case otakuPassionFire = -4
        case speech = -5
        case otakuHevened = -9
        case back = -10
    }
    
    // 発言内容開始位置取得
    func otakuSpeechIndexSelect(name: String) -> Int {

        switch name {
        case otaku_name.normal.rawValue:
            return 0;
        case otaku_name.core.rawValue:
            return 10;
        case otaku_name.bad.rawValue:
            return 20;
        default:
            break;
        }
        return 0;
    }
    // 発生時
    var otakuSpeechBox_Add: [String] = [
        // otaku_normal
        "なになに？", "アイドル？", "かわいくね？", "まあまあじゃん？", "ふ〜ん", "みえそう", "いいじゃん", "興味ないね", "萌え？", "どんなん？",
        // otaku_core
        "フヒヒ", "フシュー", "ブヒー", "いきなりマックス！", "ジュルリ", "フホッ", "突撃！", "一番を目指す", "金に糸目はつけない", "命をかける！",
        // otaku_bad
        "アイドルたるもの", "チェックしてやる", "ふ〜ん？", "お手並み拝見", "ほほう？", "なんだこれは", "これはこれは", "・・・", "…？", "ふん",
    ];
    func otakuAddSpeechGet(name: String) -> String {
        return otakuSpeechBox_Add[otakuSpeechIndexSelect(name) + Int(arc4random() % 10)];
    }

    // パッションアップ時
    var otakuSpeechBox_PassionUp: [String] = [
        // otaku_normal
        "キタキタ！", "たぎってきた", "いいかんじ", "おお！", "これは！", "みえた！", "近い！", "興味あるね", "ウェーイ！", "いい匂い",
        // otaku_core
        "神！", "神はここにいた", "可愛さが限界突破", "天にも昇る気持ち", "生きててよかった", "ウッウッ！", "感涙なり！", "これこそ我が人生！", "もっと、もっとだ！", "オッピョパヒェー！",
        // otaku_bad
        "なかなかいい", "やるじゃないか", "なるほど", "私としたことが", "これ以上は危険だ", "こんなものが", "いい。", "フムぅ〜", "私のところにきなさい", "ウチで働かないか？",
    ];
    func otakuPassionUpSpeechGet(name: String) -> String {
        return otakuSpeechBox_PassionUp[otakuSpeechIndexSelect(name) + Int(arc4random() % 10)];
    }
    
    // パッションダウン時
    var otakuSpeechBox_PassionDown: [String] = [
        // otaku_normal
        "遠いわ", "推しメン遠い", "見えねー", "おいおい", "近づきたい", "遠いぞ", "こっちこいよ", "俺だけ遠くね？", "冷めるわ〜", "みえねーじゃん",
        // otaku_core
        "遠いなり", "", "見えねー", "おいおい", "近づきたい", "遠いぞ", "こっちこいよ", "俺だけ遠くね？", "冷めるわ〜", "みえねーじゃん",
        // otaku_bad
        "ハンッ！", "こんなものか", "つまらん", "もっと楽しませろ", "くそが", "おいおい", "・・・", "所詮アイドル", "だめだな", "やれやれ",
    ];
    func otakuPassionDownSpeechGet(name: String) -> String {
        return otakuSpeechBox_PassionDown[otakuSpeechIndexSelect(name) + Int(arc4random() % 10)];
    }

    // 昇天時
    var otakuSpeechBox_GoHeven: [String] = [
        // otaku_normal
        "最高！！", "これぞアイドル！！", "激カワ！", "ウヒョー！", "超好き！", "今日キレてる！", "でそう", "ぶべら！！", "キュン死なう", "っぺピピャ！！",
        // otaku_core
        "ふぅ。", "フュヒョホー！！", "ペャ！！", "悔いなし！", "フォカヌポゥ", "・・・！（感涙", "一生ファンついていく", "一生を捧げる宣言！", "可愛すぎしんだ。", "財布が爆発した",
        // otaku_bad
        "な、なんだと！", "この私が・・・", "なんということ！", "クウゥッ！", "私の負けだ", "グォアー！！", "これで終わると思うなよ", "そんなバカな！", "一生の不覚・・・", "萌え萌えキュン！",
    ];
    func otakuGoHevenSpeechGet(name: String) -> String {
        return otakuSpeechBox_GoHeven[otakuSpeechIndexSelect(name) + Int(arc4random() % 10)];
    }

    // 帰宅時
    var otakuSpeechBox_GoHome: [String] = [
        // otaku_normal
        "冷めた", "見る価値なし", "ぶっさ", "帰るわ", "飯くい行こ", "行こうぜ", "で？", "ハイワロ", "萌えとかwww", "一生懸命さが足りない",
        // otaku_core
        "帰ろう", "帰ろう", "帰ろう", "帰ろう", "帰ろう", "帰ろう", "帰ろう", "帰ろう", "帰ろう", "帰ろう",
        // otaku_bad
        "調査対象から除外", "調査対象から除外", "調査対象から除外", "調査対象から除外", "調査対象から除外", "調査対象から除外", "調査対象から除外", "調査対象から除外", "調査対象から除外", "調査対象から除外",
    ];
    func otakuGoHomeSpeechGet(name: String) -> String {
        return otakuSpeechBox_GoHome[otakuSpeechIndexSelect(name) + Int(arc4random() % 10)];
    }

    
    let velocity_max: CGFloat = 50.0;
    let idol_velocity: CGFloat = 100.0;
    let otaku_touch_velocity: CGFloat = 100.0;
    let otaku_normal_velocity: CGFloat = 60.0;
    let otaku_core_velocity: CGFloat = 200.0;
    let otaku_bad_velocity: CGFloat = 100.0;
    
    var idol_list: [IdolBase] = [];
    let idol_collision_category: UInt32 = 0x00000001;
    var idol_move_targets: [CGPoint] = [];
    
    var otaku_list: [OtakuBase] = [];
    var otaku_active_map = Dictionary<String,OtakuBase>();
    var otaku_last_add_date: NSDate = NSDate();
    var otaku_add_interval: Int = 3;
    let otaku_collision_category: UInt32 = 0x00000002;
    var otaku_add_positions: [CGPoint] = [];
    var otaku_hevened_count: UInt = 0;
    
    var touchEffect: SKSpriteNode!;
    
    var gameFrame = CGRectZero;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // これしないと孫要素の表示順がおかしくなる
        view.ignoresSiblingOrder = false;
        
        gameFrame = CGRectMake(self.frame.origin.x
            , self.frame.origin.y + self.frame.size.height*0.15
            , self.frame.size.width
            , self.frame.size.height*0.7);
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: gameFrame);
        
        let back = SKSpriteNode(imageNamed: "back");
        back.position = view.center;
        let widthdiff = gameFrame.size.width - back.size.width;
        let heightdiff = gameFrame.size.height - back.size.height;
        if heightdiff > 0 && heightdiff >= widthdiff {
            back.xScale = gameFrame.size.height / back.size.height;
            back.yScale = gameFrame.size.height / back.size.height;
        }
        else if widthdiff > 0 && widthdiff >= heightdiff {
            back.xScale = gameFrame.size.width / back.size.width;
            back.yScale = gameFrame.size.width / back.size.width;
        }
        else {
            back.xScale = 1.0;
            back.yScale = 1.0;
        }
        back.zPosition = ZCtrl.back.rawValue;
        self.addChild(back);

        generateIdol();
        
        idolMoveSetting();
        otakuAddSetting();
    }
    
    
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {

            addTouchEffect(touch.locationInNode(self));
            
            isTouch = true;
            touchLocation = touch.locationInNode(self)
            //updateIdolVelocity(touchLocation);
            //updateOtakuVelocity_touch(touchLocation);
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            
            moveTouchEffect(touch.locationInNode(self));

            isTouch = true;
            touchLocation = touch.locationInNode(self)
            //updateIdolVelocity(touchLocation);
            //updateOtakuVelocity_touch(touchLocation);
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            isTouch = false;
            removeTouchEffect();
        }
    }
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            isTouch = false;
            removeTouchEffect();
        }
    }

    func addTouchEffect(location: CGPoint) {
        touchEffect = SKSpriteNode(imageNamed: "toucheffect");
        touchEffect.position = location;
        touchEffect.blendMode = SKBlendMode.Add;
        touchEffect.zPosition = ZCtrl.touchEffect.rawValue;
        touchEffect.alpha = 0.8;
        self.touchEffect.xScale = 1.0;
        self.touchEffect.yScale = 1.0;
        self.addChild(touchEffect);
        
        let scale = SKAction.scaleTo(2.5, duration: 0.1);
        let fade = SKAction.fadeAlphaTo(0, duration: 0.1);
        let group = SKAction.group([scale, fade]);
        let scale2 = SKAction.scaleTo(1.0, duration: 0.2);
        let fade2 = SKAction.fadeAlphaTo(0.6, duration: 0.2);
        let group2 = SKAction.group([scale2, fade2]);
        let seq = SKAction.sequence([group, group2]);
        touchEffect.runAction(SKAction.repeatActionForever(seq));
    }
    func moveTouchEffect(location: CGPoint) {
        
        if let effect = touchEffect {
            touchEffect.position = location;
        }
    }
    func removeTouchEffect() {
        
        if let effect = touchEffect {
            touchEffect.removeFromParent();
            touchEffect = nil;
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        let date_now = NSDate();
        let calendar = NSCalendar.currentCalendar()
        var comp: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitNanosecond
            , fromDate: applyforce_last_date
            , toDate: date_now
            , options:nil);
        // ミリ秒に変換
        let ms = comp.nanosecond / 100000;
        if isTouch {
            if ms > applyforce_interval {
                
                applyforce_last_date = date_now;
                
                //updateIdolVelocity(touchLocation);
                updateOtakuVelocity_touch(touchLocation);
            }
        }
        else {
            applyforce_last_date = date_now;
        }
        
        idolMove();
        updateOtaku();
        
        var compSec: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitSecond
            , fromDate: otaku_last_add_date
            , toDate: date_now
            , options:nil);
        let s = compSec.second;
        if s > otaku_add_interval /*&& otaku_active_map.count <= 0*/ {
            
            otaku_last_add_date = date_now;
            generateOtaku();
        }
    }


    func idolMoveSetting() {
        
        idol_move_targets = [CGPointMake(self.view!.center.x, self.view!.center.y)
            , CGPointMake(self.view!.center.x - gameFrame.size.width*0.25, self.view!.center.y)
            , CGPointMake(self.view!.center.x + gameFrame.size.width*0.25, self.view!.center.y)
            , CGPointMake(self.view!.center.x, self.view!.center.y - gameFrame.size.height*0.25)
            , CGPointMake(self.view!.center.x, self.view!.center.y + gameFrame.size.height*0.25)
            , CGPointMake(self.view!.center.x - gameFrame.size.width*0.25, self.view!.center.y + gameFrame.size.height*0.25)
            , CGPointMake(self.view!.center.x + gameFrame.size.width*0.25, self.view!.center.y + gameFrame.size.height*0.25)
            , CGPointMake(self.view!.center.x - gameFrame.size.width*0.25, self.view!.center.y - gameFrame.size.height*0.25)
            , CGPointMake(self.view!.center.x + gameFrame.size.width*0.25, self.view!.center.y - gameFrame.size.height*0.25)];
        
    }
    
    func generateIdol() {
        
        for i in 0 ... 1 {
            var idol = IdolBase(imageNamed:"idol_normal");
            idol.name = "idol";
            idol.position = CGPointMake((self.view!.center.x - gameFrame.size.width*0.15) + ((gameFrame.size.width*0.30) * CGFloat(i))
                , self.view!.center.y);
            idol.xScale = 0.5;
            idol.yScale = 0.5;
            idol.anchorPoint = CGPointMake(0.5, 0.5);
            idol.userInteractionEnabled = false;
            idol.zPosition = ZCtrl.idol.rawValue;
            
            idol.physicsBody = SKPhysicsBody(circleOfRadius: idol.size.width*0.5);
            idol.physicsBody?.affectedByGravity = false;
            idol.physicsBody?.restitution = 0.5;     // 反発
            idol.physicsBody?.linearDamping = 0.7;   // 減衰率
            idol.physicsBody?.friction = 0.0;          // 摩擦
            
            //そのノードがどのカテゴリか示す（デフォルトでは全てのカテゴリに含まれる）
            idol.physicsBody?.categoryBitMask = idol_collision_category;
            
            //どのカテゴリのノードと衝突した場合に、デリゲートメソッドを呼び出すか示すフラグ
            idol.physicsBody?.contactTestBitMask = 0x00000000;
            
            //どのカテゴリのノードと衝突した場合に、反射運動させるかを示すフラグ
            idol.physicsBody?.collisionBitMask = otaku_collision_category;
            
            let rot1 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
            let stay1 = SKAction.waitForDuration(0.4);
            let rot2 = SKAction.rotateByAngle(CGFloat(-(M_PI*0.05*2)), duration:0.1)
            let stay2 = SKAction.waitForDuration(0.4);
            let rot3 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
            let seq = SKAction.sequence([rot1, stay1, rot2, stay2, rot3]);
            
            idol.runAction(SKAction.repeatActionForever(seq));
            
            self.addChild(idol);
            
            idol_list.append(idol);
        }
    }
    
    func idolMove() {
        
        for idol in idol_list {
            
            if idol.isMoving {
                
                let target = idol_move_targets[Int(idol.moveTargetIndex)];
                
                var moveSeed: CGFloat = 0.002;
                moveSeed = moveSeed + (CGFloat(otaku_hevened_count) * 0.0001);
                
                // 移動
                if abs(target.x - idol.position.x) < abs(idol.moveVector.width*moveSeed) {
                    idol.position.x = target.x;
                }
                else {
                    idol.position.x += idol.moveVector.width*moveSeed;
                }
                if abs(target.y - idol.position.y) < abs(idol.moveVector.height*moveSeed) {
                    idol.position.y = target.y;
                }
                else {
                    idol.position.y += idol.moveVector.height*moveSeed;
                }
                
                let date_now = NSDate();
                let calendar = NSCalendar.currentCalendar()
                var comp: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitSecond
                    , fromDate: idol.movingDate
                    , toDate: date_now
                    , options:nil);
                let s = comp.second;
                if (s > idol.moveNextInterval) || (idol.position.x == target.x && idol.position.y == target.y)
                {
                    idol.isMoving = false;
                }
            }
            else {
                idol.moveTargetIndex = arc4random() % UInt32(idol_move_targets.count);
                let target = idol_move_targets[Int(idol.moveTargetIndex)];
                idol.moveVector = CGSizeMake(target.x - idol.position.x, target.y - idol.position.y);
                idol.movingDate = NSDate();
                idol.moveNextInterval = Int(arc4random() % 10);
                idol.isMoving = true;
            }
        }
    }
    
    
    
    func calcVelocity(velocityBase: CGFloat, baseLocation: CGPoint, touchLocation: CGPoint) -> CGVector {
        var x_dis = touchLocation.x - baseLocation.x;
        var y_dis = touchLocation.y - baseLocation.y;
        return calcVelocity_forDistance(velocityBase, distance: CGSizeMake(x_dis, y_dis));
    }
    func calcVelocity_forDistance(velocityBase: CGFloat, distance: CGSize, isApproach: Bool = false) -> CGVector {
        var x_dis: CGFloat = 0;
        var y_dis: CGFloat = 0;
        var x_vec: CGFloat = 0;
        var y_vec: CGFloat = 0;
        if isApproach {
            x_dis = abs(distance.width);
            y_dis = abs(distance.height);
            if x_dis > velocityBase { x_dis = velocityBase; }
            if y_dis > velocityBase { y_dis = velocityBase; }
            x_vec = (distance.width >= 0) ? x_dis : -x_dis;
            y_vec = (distance.height >= 0) ? y_dis : -y_dis;
        }
        else {
            x_dis = velocityBase - abs(distance.width);
            y_dis = velocityBase - abs(distance.height);
            if x_dis < 0 { x_dis = 0; }
            if y_dis < 0 { y_dis = 0; }
            x_vec = (distance.width >= 0) ? -x_dis : x_dis;
            y_vec = (distance.height >= 0) ? -y_dis : y_dis;
        }
        
        var angle = atan2(-(distance.height), distance.width);
        angle /= CGFloat(M_PI);
        angle *= 180;
        var x_angle = angle + 360;
        var y_angle = angle + 270;
        x_angle %= 180;
        x_angle = (x_angle >= 90) ? 180 - x_angle : x_angle;
        y_angle %= 180;
        y_angle = (y_angle >= 90) ? 180 - y_angle : y_angle;
        // 0.012は1/90の事だよ
        // 90度だと1になってそのままの力が加わり、0度に近づくほど加わる力が減衰するよ
        return CGVectorMake(x_vec * (y_angle*0.012), y_vec * (x_angle*0.012));
    }
    
    func updateIdolVelocity(location: CGPoint) {
        for idol in idol_list {
            var addVelocity = calcVelocity(idol_velocity
                , baseLocation: idol.position
                , touchLocation: location);
            
            addVelocity.dx = min(addVelocity.dx, velocity_max) * 0.3;
            addVelocity.dy = min(addVelocity.dy, velocity_max) * 0.3;
            idol.physicsBody?.applyForce(addVelocity);
        }
    }

    func updateOtakuVelocity_touch(location: CGPoint) {
        // タッチによる力を加える
        let keys = Array(otaku_active_map.keys);
        for i in 0 ..< keys.count {
            var otaku = otaku_active_map[keys[i]]!;
            var addVelocity = calcVelocity(otaku_touch_velocity
                , baseLocation: otaku.position
                , touchLocation: location);
            
            addVelocity.dx = min(addVelocity.dx, velocity_max) * 0.3;
            addVelocity.dy = min(addVelocity.dy, velocity_max) * 0.3;
            otaku.physicsBody?.applyForce(addVelocity);
        }
    }
    
    
    func otakuAddSetting() {
        otaku_add_positions = [
            CGPointMake(self.view!.center.x - gameFrame.size.width*0.45, self.view!.center.y - gameFrame.size.height*0.4)
            , CGPointMake(self.view!.center.x - gameFrame.size.width*0.45, self.view!.center.y + gameFrame.size.height*0.4)
            , CGPointMake(self.view!.center.x + gameFrame.size.width*0.45, self.view!.center.y - gameFrame.size.height*0.4)
            , CGPointMake(self.view!.center.x + gameFrame.size.width*0.45, self.view!.center.y + gameFrame.size.height*0.4)
        ];
    }
    
    func generateOtaku() {
        
        let seed = arc4random()%100;
        var imageName: otaku_name!;
        if seed < 15 {
            imageName = otaku_name.core;
        }
        else if seed < 30 {
            imageName = otaku_name.bad;
        }
        else {
            imageName = otaku_name.normal;
        }
        
        var otaku = OtakuBase(imageNamed:imageName.rawValue);
        otaku.name = imageName.rawValue;
        otaku.position = otaku_add_positions[Int(arc4random() % UInt32(otaku_add_positions.count))];
        otaku.xScale = 0.5;
        otaku.yScale = 0.5;
        otaku.anchorPoint = CGPointMake(0.5, 0.5);
        otaku.userInteractionEnabled = false;
        otaku.zPosition = ZCtrl.otaku.rawValue;
        
        otaku.physicsBody = SKPhysicsBody(circleOfRadius: otaku.size.width*0.5);
        otaku.physicsBody?.affectedByGravity = false;
        otaku.physicsBody?.restitution = 0.5;     // 反発
        otaku.physicsBody?.linearDamping = 0.7;   // 減衰率
        otaku.physicsBody?.friction = 0;          // 摩擦
        
        //そのノードがどのカテゴリか示す（デフォルトでは全てのカテゴリに含まれる）
        otaku.physicsBody?.categoryBitMask = otaku_collision_category;
        
        //どのカテゴリのノードと衝突した場合に、デリゲートメソッドを呼び出すか示すフラグ
        otaku.physicsBody?.contactTestBitMask = 0x00000000;
        
        //どのカテゴリのノードと衝突した場合に、反射運動させるかを示すフラグ
        otaku.physicsBody?.collisionBitMask = idol_collision_category | otaku_collision_category;
        
        let rot1 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
        let stay1 = SKAction.waitForDuration(0.4);
        let rot2 = SKAction.rotateByAngle(CGFloat(-(M_PI*0.05*2)), duration:0.1)
        let stay2 = SKAction.waitForDuration(0.4);
        let rot3 = SKAction.rotateByAngle(CGFloat(M_PI*0.05), duration:0.05)
        let seq = SKAction.sequence([rot1, stay1, rot2, stay2, rot3]);
        
        otaku.runAction(SKAction.repeatActionForever(seq));
        
        self.addChild(otaku);
        
        otaku.runSpeech(otakuAddSpeechGet(otaku.name!)
            , balloon: OtakuBase.SpeechBalloon.normal
            , action: OtakuBase.SpeechAction.normal
            , frame: 90
            , target: self, z: ZCtrl.speech.rawValue)
        
        otaku.tag = "\(otaku_list.count)"
        otaku_active_map[otaku.tag] = otaku;
        
        otaku_list.append(otaku);
    }
    
    func otakuGoHeven(otaku: OtakuBase) {
        
        otaku.runSpeech(otakuGoHevenSpeechGet(otaku.name!)
            , balloon: OtakuBase.SpeechBalloon.powerful
            , action: OtakuBase.SpeechAction.powerful
            , frame: 90
            , target: self, z: ZCtrl.speech.rawValue)

        otaku_hevened_count++;

        otaku.removeAllPaticle();

        otaku.alpha = 0.3;
        otaku.removeAllActions();
        otaku.removeAllChildren();
        otaku.physicsBody = nil;
        otaku.zPosition = ZCtrl.otakuHevened.rawValue;
        //otaku.removeFromParent();
        otaku_active_map[otaku.tag] = nil;
        
    }
    func otakuGoHome(otaku: OtakuBase) {
        
        otaku.runSpeech(otakuGoHomeSpeechGet(otaku.name!)
            , balloon: OtakuBase.SpeechBalloon.rect
            , action: OtakuBase.SpeechAction.normal
            , frame: 90
            , target: self, z: ZCtrl.speech.rawValue)
        
        otaku.removeAllPaticle();

        otaku.removeAllActions();
        otaku.removeAllChildren();
        otaku.physicsBody = nil;
        otaku.removeFromParent();
        otaku_active_map[otaku.tag] = nil;        
    }
    
    func updateOtaku() {
        
        let keys = Array(otaku_active_map.keys);
        for i in 0 ..< keys.count {
            var otaku = otaku_active_map[keys[i]]!;
            
            var idolPosition = idol_list[otaku.targetIdol].position;
            let distanceDiff = CGSizeMake(idolPosition.x - otaku.position.x, idolPosition.y - otaku.position.y);
            let distance = sqrt((abs(distanceDiff.width) * abs(distanceDiff.width)) + (abs(distanceDiff.height) * abs(distanceDiff.height)));
            //println("\(otaku.tag):distance \(distanceDiff.width),\(distanceDiff.height); \(distance)")
            
            // 熱中度を更新
            if(distance < otaku.passionAddDistanceLimit) {
                //近いほど熱くなる！
                otaku.addPassion(Int((otaku.passionAddDistanceLimit - distance) * 0.05));
                
                // 熱くなってきている演出
                otaku.addGrowPassion(self, z:ZCtrl.otakuGrowPassion.rawValue);
                otaku.removeDownPassion();
                
                // 熱い時は炎を纏う
                if( otaku.passion > otaku.newAddPassionThreshold ) {
                    
                    if let fire = otaku.passionFireParticle {}
                    else {
                        otaku.runSpeech(otakuPassionUpSpeechGet(otaku.name!)
                            , balloon: OtakuBase.SpeechBalloon.normal
                            , action: OtakuBase.SpeechAction.jump
                            , frame: 90
                            , target: self, z: ZCtrl.speech.rawValue)
                    }

                    otaku.addPassionFire(self, z:ZCtrl.otakuPassionFire.rawValue);
                }
            }
            else {
                //遠いほど冷める
                otaku.addPassion(Int((distance - otaku.passionAddDistanceLimit) * -0.05));
                
                // 冷めている演出消す
                if(otaku.passion > 0) {
                    
                    if let down = otaku.downPassionParticle {}
                    else {
                        otaku.runSpeech(otakuPassionDownSpeechGet(otaku.name!)
                            , balloon: OtakuBase.SpeechBalloon.rect
                            , action: OtakuBase.SpeechAction.normal
                            , frame: 90
                            , target: self, z: ZCtrl.speech.rawValue)
                    }

                    otaku.addDownPassion(self, z: ZCtrl.otakuDownPassion.rawValue);
                }
                else {
                    otaku.removeDownPassion();
                }
                otaku.removeGrowPassion();

                // 冷めたら炎も消える
                if( otaku.passion < otaku.newAddPassionThreshold ) {
                    otaku.removePassionFire();
                }
            }
            
            // 昇天するか
            if(otaku.isGoToHeven())
            {
                otakuGoHeven(otaku);
                return;
            }
            
            // 帰宅するか
            if(otaku.isGoHome())
            {
                otakuGoHome(otaku);
                return;
            }
            
            if otaku.addNewOtaku() {
                generateOtaku();
            }
            
            // 熱中度によるアイドルへの接近力を加える
            var baseVelocity = otaku.physicsBody!.velocity;
            var addVelocity: CGVector!;
            var otakuPassion: CGFloat = CGFloat(otaku.passion) * 0.0001;
            var otakuPassionSeed = (otakuPassion < 0) ? 0.02 : 0.02 + otakuPassion;
            //println("\(otaku.tag):passion \(otakuPassion), \(otakuPassionSeed)")
            
            // 距離と熱中度により算出して設定　今はダミー
            switch otaku.name! {
            case otaku_name.normal.rawValue:
                addVelocity = calcVelocity_forDistance(otaku_normal_velocity*otakuPassionSeed
                    , distance: CGSizeMake(distanceDiff.width*otakuPassionSeed, distanceDiff.height*otakuPassionSeed)
                    , isApproach: true);
            case otaku_name.core.rawValue:
                otakuPassionSeed *= 2;
                addVelocity = calcVelocity_forDistance(otaku_core_velocity*otakuPassionSeed
                    , distance: CGSizeMake(distanceDiff.width*otakuPassionSeed, distanceDiff.height*otakuPassionSeed)
                    , isApproach: true);
            case otaku_name.bad.rawValue:
                addVelocity = calcVelocity_forDistance(otaku_bad_velocity*otakuPassionSeed
                    , distance: CGSizeMake(distanceDiff.width*otakuPassionSeed, distanceDiff.height*otakuPassionSeed)
                    , isApproach: true);
            default:
                break;
            }
            
            if let add = addVelocity {
                var vec = CGVectorMake(add.dx, add.dy);
                vec.dx = min(vec.dx, velocity_max);
                vec.dy = min(vec.dy, velocity_max);
                otaku.physicsBody?.applyForce(vec);
            }
            
            // パーティクルの位置を更新
            otaku.updateAllParticle();
        }
    }    
}
