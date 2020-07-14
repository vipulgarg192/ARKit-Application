//
//  WomenUI.swift
//  ARDice
//
//  Created by vipul garg on 2020-07-08.
//  Copyright © 2020 VipulGarg. All rights reserved.
//

import SceneKit
import ARKit
import RealityKit


class ArViewClass: UIViewController, ARSCNViewDelegate {
    
    var diceArray = [SCNNode].self

        
    @IBOutlet weak var sceneView: ARView!
    
    
    override func viewDidLoad() {
            
                  do {
                          let vase = try ModelEntity.load(named: "women1")
                    vase.scene
                          
                          // Place model on a horizontal plane.
                          let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
                          sceneView.scene.anchors.append(anchor)
                          
                          vase.scale = [1, 1, 1] * 0.006
                          anchor.children.append(vase)
                      } catch {
                          fatalError("Failed to load asset.")
                      }
                
    }
  
        
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        if ARWorldTrackingConfiguration.isSupported {
////            // Create a session configuration
////            let configuration = ARWorldTrackingConfiguration()
////
//////            configuration.planeDetection = .horizontal
////
////            // Run the view's session
////            sceneView.session.run(configuration)
////        }
//
//        if ARWorldTrackingConfiguration.isSupported {
//                    // Create a session configuration
//                    let config = ARWorldTrackingConfiguration()
//        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
//            fatalError("People occlusion is not supported on this device.")
//        }
//        switch config.frameSemantics {
//        case [.personSegmentationWithDepth]:
//            config.frameSemantics.remove(.personSegmentationWithDepth)
//            print("People occlusion off")
//        default:
//            config.frameSemantics.insert(.personSegmentationWithDepth)
//            print("People occlusion on")
//
//        }
//        sceneView.session.run(config)
//        }
//    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.togglePeopleOcclusion()
    }

    
    
    fileprivate func togglePeopleOcclusion() {
        guard let config = sceneView.session.configuration as? ARWorldTrackingConfiguration else {
            fatalError("Unexpectedly failed to get the configuration.")
        }
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("People occlusion is not supported on this device.")
        }
        switch config.frameSemantics {
        case [.personSegmentationWithDepth]:
            config.frameSemantics.remove(.personSegmentationWithDepth)
        default:
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

           sceneView.session.pause()
       }
       
        

    
}
        
    
