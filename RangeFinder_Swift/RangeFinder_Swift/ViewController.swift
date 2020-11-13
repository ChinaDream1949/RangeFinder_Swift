//
//  ViewController.swift
//  RangeFinder_Swift
//
//  Created by MR.Sahw on 2020/11/13.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var nodes : [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = .showFeaturePoints // 特征点调试
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 判断
        if nodes.count >= 2 {
            for node in nodes {
                node.removeFromParentNode()
            }
            nodes = []
        }
        
        guard let location = touches.first?.location(in: sceneView) else {return}
        guard let result = sceneView.hitTest(location, types: .featurePoint).first else {return}
        let position = result.worldTransform.columns.3
        
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.yellow
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(position.x, position.y, position.z)
        sceneView.scene.rootNode.addChildNode(node)
        
        nodes.append(node)
        if nodes.count >= 2 {
            let p1 = nodes[0].position
            let p2 = nodes[1].position
            
            let distance = abs(sqrt(pow(p1.x-p2.x, 2) + pow(p1.y-p2.y, 2) + pow(p1.z-p2.z, 2)))
            distanceLabel.text = String(distance)
        }
    }
}
