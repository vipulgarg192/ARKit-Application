//
//  WomenUI.swift
//  ARDice
//
//  Created by vipul garg on 2020-07-08.
//  Copyright © 2020 VipulGarg. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RealityKit


class WomenUI: UIViewController, ARSCNViewDelegate {
    
    var diceArray = [SCNNode].self

        
    @IBOutlet weak var sceneView: ARSCNView!
    
    var sceneNode = SCNNode()
    override func viewDidLoad() {
            super.viewDidLoad()
        
            self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
            // Set the view's delegate
            sceneView.delegate = self
            
            // Create a new scene
            let scene = SCNScene(named: "art.scnassets/women12.scn")!
            sceneView.autoenablesDefaultLighting = true
            // Set the scene to the view

            sceneNode = scene.rootNode.childNode(withName : "_material_1", recursively : true)!
            sceneNode.position  = SCNVector3(x: 0, y: -537.073, z: -830.574)
            sceneView.scene.rootNode.addChildNode(sceneNode)
        
        
        
      
        
        
//        let scene = SCNScene(named: "art.scnassets/dress.scn")!
//            sceneView.autoenablesDefaultLighting = true
            // Set the scene to the view
        
//        var nodeArray = scene.rootNode.childNodes
//    print(nodeArray.count)
//        for childNode in nodeArray {
//          sceneNode.addChildNode(childNode as SCNNode)
//        }

//            sceneView.scene.rootNode.addChildNode(sceneNode)
//        sceneNode = scene.rootNode.childNode(withName : "dress", recursively : true)!
//                   sceneNode.position  = SCNVector3(x: 0, y: -537.073, z: -830.574)
//
//                    sceneView.scene.rootNode.addChildNode(sceneNode)
            
        
        }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if ARWorldTrackingConfiguration.isSupported {
//            // Create a session configuration
//            let configuration = ARWorldTrackingConfiguration()
//
//            configuration.planeDetection = .horizontal
//
//            // Run the view's session
//            sceneView.session.run(configuration)
//        }
        
        if ARWorldTrackingConfiguration.isSupported {
                    // Create a session configuration
                    let config = ARWorldTrackingConfiguration()
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("People occlusion is not supported on this device.")
        }
        switch config.frameSemantics {
        case [.personSegmentationWithDepth]:
            config.frameSemantics.remove(.personSegmentationWithDepth)
            print("People occlusion off")
        default:
            config.frameSemantics.insert(.personSegmentationWithDepth)
            print("People occlusion on")

        }
        sceneView.session.run(config)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

           sceneView.session.pause()
       }
       
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
          let touchLocation = touch.location(in: sceneView)
          
          let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitresult = results.first {
                  let diceScene = SCNScene(named: "art.scnassets/women12.scn")!
                
                print("Dice scene:")
                
                if let diceNode = diceScene.rootNode.childNode(withName : "_material_1", recursively : true){
                    
                    diceNode.position = SCNVector3(x: hitresult.worldTransform.columns.3.x,
                        y: hitresult.worldTransform.columns.3.y,
                        z: hitresult.worldTransform.columns.3.z
                    )
                    diceNode.scale = SCNVector3Make(Float(0.2), Float(0.2), Float(0.2))
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    let randomX = Float(arc4random_uniform(4)) * (Float.pi/2)
                    let randomY = Float(arc4random_uniform(4)) * (Float.pi/2)

                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomY * 5), duration: 1))
                    
                }

                
            }
        
            }
        
//         let randomX = Float(arc4random_uniform(4)) * (Float.pi/2)
//                           let randomY = Float(arc4random_uniform(2)) * (Float.pi/2)
//
//                           sceneNode.runAction(SCNAction.rotateBy(x: 0, y: CGFloat(randomY * 5), z: 0, duration: 1))
    
    
    }
    
    
    
    
    
    
}
        
    
