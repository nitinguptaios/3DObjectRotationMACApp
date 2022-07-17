//
//  ThreeDPortalViewController.swift
//  ThreeDPortalFilemaker
//
//  Created by iPHTech36 on 23/06/22.
//

import Cocoa
import SceneKit

class ThreeDPortalViewController: NSViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var toolView: NSView!
    @IBOutlet weak var tableView: NSTableView!

    //MARK: Constants
    private let teethArray = [1.8, 1.7, 1.6, 1.5, 1.4, 1.3, 1.2, 1.1,
                              2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8,
                              3.8, 3.7, 3.6, 3.5, 3.4, 3.3, 3.2, 3.1,
                              4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8]
    
    private var xPoint = ["","","","","","","","",
                          "","","","","","","","",
                          "","","","","","","","",
                          "","","","","","","",""]
    private var yPoint = ["","","","","","","","",
                          "","","","","","","","",
                          "","","","","","","","",
                          "","","","","","","",""]
    private var zPoint = ["","","","","","","","",
                          "","","","","","","","",
                          "","","","","","","","",
                          "","","","","","","",""]

    //MARK: Variable
    private var isPointAddMode = false
    private var startingPoint: SCNVector3!
    private var endingPoint: SCNVector3!
    
    private var tempPath = [String]()
    private var firstPoint = false
    private var SecondPoint = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: Setup initial UI.
    private func setupUI() {
        hideInfoLabel(hideStatus: false)
        toolView.isHidden = true
    }
    
    private func hideInfoLabel(hideStatus: Bool) {
        sceneView.isHidden = !hideStatus
        infoLabel.isHidden = hideStatus
    }
    
    //MARK: Load 3D Model.
    func load3DModel(path: [String]) {
        
        if path.count != 0 {
            hideInfoLabel(hideStatus: true)
            loadModel(path: path)
            
            tempPath = path
        }
        else {
            hideInfoLabel(hideStatus: false)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(handleDoubleClick)
    }
    
    @objc func handleDoubleClick() {
        let clickedRow = tableView.clickedRow
        print(clickedRow)
    }
    
    private func loadModel(path: [String]) {
        
        do {
            let objectScene = try SCNScene(url: URL(fileURLWithPath: path[0]))
            if path.count >= 2 {
                for index in 1...path.count-1 {
                    let subObjectScene = try SCNScene(url: URL(fileURLWithPath: path[index]))
                    let subObjectNode = subObjectScene.rootNode
                    objectScene.rootNode.addChildNode(subObjectNode)
                    break
                }
            }
            
            let camera = SCNCamera ()
            let cameraNode = SCNNode ()
            cameraNode.camera = camera
            cameraNode.position = SCNVector3Make(21.858455657958984, -164.68035888671875, 18.612308502197266) //set your camera position
            cameraNode.scale = SCNVector3(x: 3, y: 3, z: 3)
            cameraNode.eulerAngles = SCNVector3(x: 1.5436961650848389, y: 0.0005130171775817871, z: 0.1313169151544571)
            objectScene.rootNode.addChildNode(cameraNode)
            
            sceneView.allowsCameraControl = true
            sceneView.autoenablesDefaultLighting = true
            sceneView.scene = objectScene
            
            sceneView.defaultCameraController.interactionMode = .orbitAngleMapping
            sceneView.defaultCameraController.inertiaEnabled = true
            sceneView.defaultCameraController.maximumVerticalAngle = 90
            sceneView.defaultCameraController.minimumVerticalAngle = -90
            sceneView.defaultCameraController.maximumHorizontalAngle = 90
            sceneView.defaultCameraController.minimumHorizontalAngle = 90

            let appDelegate = UtilityFunctions.shared.getAppDelegate()
            appDelegate?.configureViewMenu()
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func addPointAction(_ sender: NSButtonCell ) {
        enableDisableModelControlAction(status: false)
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(addPointGesture(gestureRecognize:)))
        firstPoint = true
        SecondPoint = false
        sceneView.addGestureRecognizer(clickGesture)
    }
    
    @IBAction func secondPoint(_ sender: NSButtonCell) {
        enableDisableModelControlAction(status: false)
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(addPointGesture(gestureRecognize:)))
        firstPoint = false
        SecondPoint = true
        sceneView.addGestureRecognizer(clickGesture)
    }
    
    @IBAction func addLineAction(_ sender: NSButtonCell ) {
        let twoPointsNode1 = SCNNode()
      //  sceneView.scene?.rootNode.addChildNode(twoPointsNode1.buildLineInTwoPointsWithRotation(from: SCNVector3(x: 4.084815979003906, y: -23.113937377929688, z: 23.334442138671875), to: SCNVector3(x: 9.251986503601074, y: -20.199172973632812, z: 4.768872261047363), radius: 0.2, color: .cyan))
          sceneView.scene?.rootNode.addChildNode(twoPointsNode1.buildLineInTwoPointsWithRotation(from: startingPoint, to: endingPoint, radius: 0.2, color: .cyan))

        
        sceneView.scene = sceneView.scene //add scene to your SCNView
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.defaultCameraController.interactionMode = .orbitAngleMapping
        sceneView.defaultCameraController.inertiaEnabled = true
        sceneView.defaultCameraController.maximumVerticalAngle = 180
        sceneView.defaultCameraController.minimumVerticalAngle = -180
        sceneView.defaultCameraController.maximumHorizontalAngle = 180
        sceneView.defaultCameraController.minimumHorizontalAngle = 180
    }

    private func enableDisableModelControlAction(status: Bool) {
        sceneView.allowsCameraControl = status
        isPointAddMode = !status
    }

}

//MARK: extension ViewMenu
extension ThreeDPortalViewController {

    func designViewTap(openCloseStatus: Bool) {
        
        toolView.isHidden = !openCloseStatus

        if openCloseStatus {

            if let childNode = sceneView.scene?.rootNode.childNodes {
                for index in 0...childNode.count-1 {
                    let node = childNode[index]
                    if index == 1 {
                        node.position = SCNVector3Make(0, -5, 20)
                        node.eulerAngles = SCNVector3(x: 150, y: 0, z: 0)
                    }
                }
            }
        }
        else {
            if let childNode = sceneView.scene?.rootNode.childNodes {
                for index in 0...childNode.count-1 {
                    let node = childNode[index]
                    if index == 1 {
                        node.position = SCNVector3Make(0, 0, 0)
                        node.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
                    }
                }
            }
        }
    }
}

extension ThreeDPortalViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return teethArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "teethNumber") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "teethNumber")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField!.stringValue = "\(teethArray[row])"
            
            return cellView
            
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "x") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "x")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField!.stringValue = xPoint[row]
            return cellView
            
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "y") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "y")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField!.stringValue = yPoint[row]
            return cellView
            
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "z") {
            
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "z")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField!.stringValue = zPoint[row]
            return cellView
            
        }else {
            
        }
        
        return nil
    }
    
    
    
}

extension ThreeDPortalViewController {
    
    @objc func addPointGesture(gestureRecognize: NSClickGestureRecognizer) {
        
        if true { //isPointAddMode
            let tocuhPoint = gestureRecognize.location(in: sceneView)
            let scenePoint = sceneView.hitTest(tocuhPoint, options: [.searchMode:0])
            let resultPoint =  scenePoint.first
            
            
            if gestureRecognize.state == .ended && resultPoint != nil {
                
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 2.0))
                sphereNode.position = SCNVector3((resultPoint?.simdWorldCoordinates.x)!, (resultPoint?.simdWorldCoordinates.y)!, ((resultPoint?.simdWorldCoordinates.z)!))
                sphereNode.geometry?.firstMaterial?.diffuse.contents = NSColor.red
                //sphereNode.eulerAngles = SCNVector3(x: -100, y: 0, z: 0)
                sceneView.scene?.rootNode.addChildNode(sphereNode)
                enableDisableModelControlAction(status: true)
                
                if firstPoint {
                    startingPoint = SCNVector3((resultPoint?.simdWorldCoordinates.x)!, (resultPoint?.simdWorldCoordinates.y)!, ((resultPoint?.simdWorldCoordinates.z)!))
                }
                else if SecondPoint {
                    endingPoint = SCNVector3((resultPoint?.simdWorldCoordinates.x)!, (resultPoint?.simdWorldCoordinates.y)!, ((resultPoint?.simdWorldCoordinates.z)!))
                }
                
                let clickedRow = tableView.selectedRow + 1
                xPoint.insert("\((resultPoint?.simdWorldCoordinates.x)!)", at: clickedRow)
                yPoint.insert("\((resultPoint?.simdWorldCoordinates.y)!)", at: clickedRow)
                zPoint.insert("\((resultPoint?.simdWorldCoordinates.z)!)", at: clickedRow)
            }
            
            tableView.reloadData()
        }
    }
}

extension SCNNode {
    
    func buildLineInTwoPointsWithRotation(from startPoint: SCNVector3,
                                          to endPoint: SCNVector3,
                                          radius: CGFloat,
                                          color: NSColor) -> SCNNode {
        let w = SCNVector3(x: endPoint.x-startPoint.x,
                           y: endPoint.y-startPoint.y,
                           z: endPoint.z-startPoint.z)
        let l = CGFloat(sqrt(w.x * w.x + w.y * w.y + w.z * w.z))
        
        if l == 0.0 {
            // two points together.
            let sphere = SCNSphere(radius: radius)
            sphere.firstMaterial?.diffuse.contents = color
            self.geometry = sphere
            self.position = startPoint
            return self
            
        }
        
        let cyl = SCNCylinder(radius: radius, height: l)
        cyl.firstMaterial?.diffuse.contents = color
        
        self.geometry = cyl
        
        //original vector of cylinder above 0,0,0
        let ov = SCNVector3(0, l/2.0,0)
        //target vector, in new coordination
        let nv = SCNVector3((endPoint.x - startPoint.x)/2.0, (endPoint.y - startPoint.y)/2.0,
                            (endPoint.z-startPoint.z)/2.0)
        
        // axis between two vector
        let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
        
        //normalized axis vector
        let av_normalized = normalizeVector(av)
        let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
        let q1 = Float(av_normalized.x) // x' * sin(angle/2)
        let q2 = Float(av_normalized.y) // y' * sin(angle/2)
        let q3 = Float(av_normalized.z) // z' * sin(angle/2)
        
        let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
        let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
        let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
        let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
        let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
        let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
        let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
        let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
        let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
        
        self.transform.m11 = CGFloat(r_m11)
        self.transform.m12 = CGFloat(r_m12)
        self.transform.m13 = CGFloat(r_m13)
        self.transform.m14 = 0.0
        
        self.transform.m21 = CGFloat(r_m21)
        self.transform.m22 = CGFloat(r_m22)
        self.transform.m23 = CGFloat(r_m23)
        self.transform.m24 = 0.0
        
        self.transform.m31 = CGFloat(r_m31)
        self.transform.m32 = CGFloat(r_m32)
        self.transform.m33 = CGFloat(r_m33)
        self.transform.m34 = 0.0
        
        self.transform.m41 = (startPoint.x + endPoint.x) / 2.0
        self.transform.m42 = (startPoint.y + endPoint.y) / 2.0
        self.transform.m43 = (startPoint.z + endPoint.z) / 2.0
        self.transform.m44 = 1.0
        return self
    }
    
    func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
        let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
        if length == 0 {
            return SCNVector3(0.0, 0.0, 0.0)
        }
        
        return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
        
    }
}
