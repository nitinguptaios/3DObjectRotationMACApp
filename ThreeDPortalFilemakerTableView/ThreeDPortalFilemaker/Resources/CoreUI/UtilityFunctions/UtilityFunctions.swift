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

}
