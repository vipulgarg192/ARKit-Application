//
//  ImageTrackingUI.swift
//  ARDice
//
//  Created by vipul garg on 2020-07-13.
//  Copyright © 2020 VipulGarg. All rights reserved.
//

import SceneKit
import ARKit
import RealityKit

class ImageTrackingUI: UIViewController, ARSCNViewDelegate {
    
      @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
            // Set the view's delegate
            sceneView.delegate = self
            
            // Show statistics such as fps and timing information
            sceneView.showsStatistics = true
            
            sceneView.autoenablesDefaultLighting = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Create a session configuration
               let configuration = ARImageTrackingConfiguration()
               
               if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "cards", bundle: Bundle.main) {
                   
                   configuration.trackingImages = imageToTrack
                   
                   configuration.maximumNumberOfTrackedImages = 1
                   
                   print("Images Successfully Added")

                   
               }
               
               
               

               // Run the view's session
               sceneView.session.run(configuration)
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)

              sceneView.session.pause()
          }
          
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            
            let node = SCNNode()
            
            if let imageAnchor = anchor as? ARImageAnchor {
                
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 1)

                let planeNode = SCNNode(geometry: plane)
                
                planeNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(planeNode)
                
                if imageAnchor.referenceImage.name == "card" {
                    if let arScene = SCNScene(named: "art.scnassets/vase.scn") {
    
                        if let arnode = arScene.rootNode.childNodes.first {
    
                            arnode.eulerAngles.x = .pi / 2
    
                            planeNode.addChildNode(arnode)
                        }
                    }
                }
                
            }
            
            
            
            return node
            
        }

}
