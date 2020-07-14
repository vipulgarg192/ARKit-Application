//
//  ARRuller.swift
//  ARDice
//
//  Created by vipul garg on 2020-07-01.
//  Copyright © 2020 VipulGarg. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import UIKit


class ARRuller : UIViewController, ARSCNViewDelegate {
    
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
     @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.delegate = self
//
//        let scene = SCNScene(named: "art.scnassets/dress.scn")!
//
//          let material = SCNMaterial()
//                 material.diffuse.contents = UIImage(named: "art.scnassets/mars.jpg")
//
//
//        if let sceneNode = scene.rootNode.childNode(withName : "dress", recursively : true){
//            sceneNode.position  = SCNVector3(x: 0, y: 0.1, z: -0.5)
//            sceneView.scene.rootNode.addChildNode(sceneNode)
//    }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
         if let  touchLocations = touches.first?.location(in: sceneView){
            
        let hitTestResults = sceneView.hitTest(touchLocations, types: .featurePoint)
            
            if let hitResults = hitTestResults.first{
                addDot(at : hitResults)
            }
            
        }
        
    }
    
    func addDot(at hitResult : ARHitTestResult)  {
let dot = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dot.materials = [material]
        
        let dotNode = SCNNode(geometry: dot)
        
        dotNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y, z: hitResult.worldTransform.columns.3.z)
     
        sceneView.scene.rootNode.addChildNode(dotNode)
        
     dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
        
      
        
    }
    
    func calculate(){
        let start = dotNodes[0]
        let end = dotNodes[1]
        print("start \(start)")
        print("end \(end)")
        var midpoint = CGFloat()
        if start.position.x >= end.position.x {
            midpoint = CGFloat(start.position.x - end.position.x)
        }else {
            midpoint = CGFloat(end.position.x - start.position.x)
        }
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        print(distance)
          
        updateText(text: "\(abs(distance))", atPosition: end.position,midPoint: midpoint , startPoint : start.position)

    }
    
    func updateText(text: String , atPosition: SCNVector3 , midPoint: CGFloat , startPoint: SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
         textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(startPoint.x ,atPosition.y + 0.01 ,atPosition.z + -0.01)
        textNode.scale = SCNVector3(0.005 , 0.005 , 0.005)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        print("asd")
//    }
    
}
