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
    @IBOutlet weak var teethTableView: NSTableView!
    @IBOutlet weak var enableAddPointButton: NSButton!
    @IBOutlet weak var addLineButton: NSButton!
    @IBOutlet weak var addedPointTableView: NSTableView!
    //enableAddPoint
    
    //MARK: Constants
    private var teethArray: [CGFloat] = [1.8, 1.7, 1.6, 1.5, 1.4, 1.3, 1.2, 1.1,
                                         2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8,
                                         3.8, 3.7, 3.6, 3.5, 3.4, 3.3, 3.2, 3.1,
                                         4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8]
    
    
    //MARK: Variable
    private var isPointAddMode = false
    private var addedTeethPointArray = [CGFloat]()
    
    private var lineArray = [Line]()
    private var pointA: Point?
    private var pointB: Point?
    private var startingPoint: SCNVector3?
    private var endingPoint: SCNVector3?
    private var isLineAddEnable = false
    
    
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
        }
        else {
            hideInfoLabel(hideStatus: false)
        }
        
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
    
    //MARK: Add point action.
    @IBAction func addPointAction(_ sender: NSButtonCell ) {
        
        enableDisableModelControlAction(status: false)
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(addPointGesture(gestureRecognize:)))
        sceneView.addGestureRecognizer(clickGesture)
        enableAddPointButton.bezelColor = .blueColor
    }
    
    private func enableDisableModelControlAction(status: Bool) {
        sceneView.allowsCameraControl = true//status
        isPointAddMode = true//!status
    }
    
    //MARK: Add line action.
    @IBAction func addLineAction(_ sender: NSButtonCell ) {
        
        if startingPoint != nil && endingPoint != nil {
            sceneView.scene?.rootNode.addChildNode(SCNNode().buildLineInTwoPointsWithRotation(from: startingPoint!, to: endingPoint!, radius: 0.2, color: .blue))
            lineArray.append(Line(pointA: pointA, pointB: pointB))
            resetPoint()
        }
    }
    
    private func resetPoint() {
        
        startingPoint = nil
        endingPoint = nil
        pointA = nil
        pointB = nil
        isLineAddEnable = false
    }
    
    //MARK: Save Button action.
    @IBAction func saveButtonAction(_ sender: NSButtonCell ) {
        
        let extraPointline = Line(pointA: pointA, pointB: pointB)
        if extraPointline.pointA != nil || extraPointline.pointB != nil  {
            lineArray.append(extraPointline)
        }
        
        var post = "<?xml version='1.0' encoding='UTF-8'?>"
        post.append("\n<AddedLines>")
        for line in lineArray {
            post.append("""
                                \n <line>
                                  <pointA>
                                   <teethNumber>\(String(describing: line.pointA?.teethNumber ?? 0.0))</teethNumber>
                                   <x>\(String(describing: line.pointA?.point?.x ?? 0.0))</x>
                                   <y>\(String(describing: line.pointA?.point?.y ?? 0.0))</y>
                                   <z>\(String(describing: line.pointA?.point?.z ?? 0.0))</z>
                                  </pointA>
                                  <pointB>
                                   <teethNumber>\(String(describing: line.pointB?.teethNumber ?? 0.0))</teethNumber>
                                   <x>\(String(describing: line.pointB?.point?.x ?? 0.0))</x>
                                   <y>\(String(describing: line.pointB?.point?.y ?? 0.0))</y>
                                   <z>\(String(describing: line.pointB?.point?.z ?? 0.0))</z>
                                  </pointB>
                                 </line>
                                """)
        }
        post.append("\n</AddedLines>")
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "ToothSample.xml"
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result: NSApplication.ModalResponse) -> Void in
            if result == NSApplication.ModalResponse.OK {
                if let panelURL = savePanel.url {
                    do {
                        try post.write(to: panelURL, atomically: true, encoding: .utf8)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        
    }
    
}

//MARK: extension ViewMenu
extension ThreeDPortalViewController {
    
    func designViewTap(openCloseStatus: Bool) {
        
        toolView.isHidden = !openCloseStatus
        isPointAddMode = openCloseStatus
        
        if openCloseStatus {
            
            teethArray = [1.8, 1.7, 1.6, 1.5, 1.4, 1.3, 1.2, 1.1,
                          2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8,
                          3.8, 3.7, 3.6, 3.5, 3.4, 3.3, 3.2, 3.1,
                          4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8]
            addedTeethPointArray.removeAll()
            lineArray.removeAll()
            reloadTableData()
            resetPoint()
            
            if let childNode = sceneView.scene?.rootNode.childNodes {
                for index in 0...childNode.count-1 {
                    let node = childNode[index]
                    if index == 1 {
                        node.position.z = 20
                        node.eulerAngles.x = 150
                    }
                }
            }
        }
        else {
            if let childNode = sceneView.scene?.rootNode.childNodes {
                for index in 0...childNode.count-1 {
                    let node = childNode[index]
                    if index == 1 {
                        node.position.z = 0
                        node.eulerAngles.x = 0
                    }
                    if index > 2 {
                        node.removeFromParentNode()
                    }
                }
            }
        }
    }
}

extension ThreeDPortalViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == teethTableView {
            return teethArray.count
        }
        else {
            return addedTeethPointArray.count
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        cell.textField!.stringValue = "\(teethArray[row])"
        if tableView == teethTableView {
            cell.textField!.stringValue = "\(teethArray[row])"
        }
        else {
            cell.textField!.stringValue = "\(addedTeethPointArray[row])"
        }
        return cell
    }
}

extension ThreeDPortalViewController {
    
    @objc func addPointGesture(gestureRecognize: NSClickGestureRecognizer) {
        
        if teethTableView.selectedRow == -1 {
            UtilityFunctions.shared.showAlert(message: "Alert", info: "Please select point")
        }
        else if isLineAddEnable {
            UtilityFunctions.shared.showAlert(message: "Alert", info: "Please add line")
        }
        else if isPointAddMode {
            let tocuhPoint = gestureRecognize.location(in: sceneView)
            let scenePoint = sceneView.hitTest(tocuhPoint, options: [.searchMode:1])
            let resultPoint =  scenePoint.first
            if gestureRecognize.state == .ended && resultPoint != nil {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 2.0))
                sphereNode.geometry?.firstMaterial?.diffuse.contents = NSColor.red
                sphereNode.position = SCNVector3((resultPoint?.simdWorldCoordinates.x)!, (resultPoint?.simdWorldCoordinates.y)!+1.5, ((resultPoint?.simdWorldCoordinates.z)!))//localCoordinates working fine without opening model.
                sceneView.scene?.rootNode.addChildNode(sphereNode)
                enableDisableModelControlAction(status: true)
                
                if pointA == nil {
                    pointA = Point(teethNumber: teethArray[teethTableView.selectedRow], point: resultPoint!.simdWorldCoordinates)
                    startingPoint = SCNVector3((resultPoint?.simdWorldCoordinates.x)!, (resultPoint?.simdWorldCoordinates.y)!, ((resultPoint?.simdWorldCoordinates.z)!))
                }
                else {
                    pointB = Point(teethNumber: teethArray[teethTableView.selectedRow], point: resultPoint!.simdWorldCoordinates)
                    endingPoint = SCNVector3((resultPoint?.simdWorldCoordinates.x)!, (resultPoint?.simdWorldCoordinates.y)!, ((resultPoint?.simdWorldCoordinates.z)!))
                    isLineAddEnable = true
                }
                
                refreshTableData()
                
            }
        }
    }
    
    private func refreshTableData() {
        let selectedIndex = teethTableView.selectedRow
        addedTeethPointArray.append(teethArray[selectedIndex])
        teethArray.remove(at: selectedIndex)
        reloadTableData()
    }
    
    private func reloadTableData() {
        teethTableView.reloadData()
        addedPointTableView.reloadData()
    }
    
}
