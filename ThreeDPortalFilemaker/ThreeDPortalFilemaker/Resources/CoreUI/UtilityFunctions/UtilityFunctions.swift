//
//  UtilityFunctions.swift
//  ThreeDPortalFilemaker
//
//  Created by iPHTech36 on 29/06/22.
//

import Cocoa

class UtilityFunctions {
    
    static let shared = UtilityFunctions()
    
    private init() {}

    func getAppDelegate() -> AppDelegate? {
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            return appDelegate
        }
        return nil
    }
    
    func showAlert(message: String, info: String) {
        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = info
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
//        alert.addButton(withTitle: "Cancel")
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
//            return true
        }
//        return false
    }

}
