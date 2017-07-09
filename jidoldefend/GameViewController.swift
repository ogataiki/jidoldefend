//
//  GameViewController.swift
//  jidoldefend
//
//  Created by taiki.ogasawara on 2015/07/06.
//  Copyright (c) 2015年 ogataiki. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            do {
                let sceneData = try Data(contentsOf: URL(fileURLWithPath: path));
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
                archiver.finishDecoding()
                return scene
            } catch {
                return nil;
            }
            
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsDrawCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            scene.size = skView.frame.size;

            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return UIInterfaceOrientationMask.allButUpsideDown
            } else {
                return UIInterfaceOrientationMask.all
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
