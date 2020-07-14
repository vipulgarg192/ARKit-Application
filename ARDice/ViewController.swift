//
//  ViewController.swift
//  ARDice
//
//  Created by vipul garg on 2020-06-30.
//  Copyright © 2020 VipulGarg. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var diceArray = [SCNNode].self

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Set the view's delegate
        sceneView.delegate = self
        
    
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
         
        
//        let sphere = SCNSphere(radius: 0.2)
//        let material = SCNMaterial()
//         material.diffuse.contents = UIImage(named: "art.scnassets/mars.jpg")
//
//        sphere.materials = [material]
//        let node = SCNNode()
//        node.geometry?.firstMaterial?.diffuse.contents = UIImage(contentsOfFile: "moon.png")
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
//
        sceneView.autoenablesDefaultLighting = true
        // Set the scene to the view
        
if let sceneNode = scene.rootNode.childNode(withName : "dress", recursively : true){
//    sceneNode.position  = SCNVector3(x: 0, y: 0.1, z: -0.5)
    sceneView.scene.rootNode.addChildNode(sceneNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ARWorldTrackingConfiguration.isSupported {
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            
            configuration.planeDetection = .horizontal
            

            // Run the view's session
            sceneView.session.run(configuration)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitresult = results.first {
                  let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                print("Dice scene:")
                
                if let diceNode = diceScene.rootNode.childNode(withName : "Dice", recursively : true){
                    
                    print("to")
                    diceNode.position = SCNVector3(x: hitresult.worldTransform.columns.3.x,
                        y: hitresult.worldTransform.columns.3.y,
                        z: hitresult.worldTransform.columns.3.z
                    )
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    let randomX = Float(arc4random_uniform(4)) * (Float.pi/2)
                    let randomY = Float(arc4random_uniform(4)) * (Float.pi/2)
                    
                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomY * 5), duration: 1))
                    
                }

                
            }
//            if !results.isEmpty {
//                print("Touched")
//            }
//            else{
//                print("Touch somewhere else")
//            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x , 0 , planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMatrial = SCNMaterial()
            gridMatrial.diffuse.contents = UIImage(named: "art.scnassets/mars.jpg")
            plane.materials = [gridMatrial]
            planeNode.geometry = plane
//            node.addChildNode(planeNode)
        }else{
            return
        }
    }
}
