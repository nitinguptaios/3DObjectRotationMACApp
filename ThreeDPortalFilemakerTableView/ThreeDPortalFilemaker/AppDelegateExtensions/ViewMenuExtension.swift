//
//  ViewMenuExtension.swift
//  ThreeDPortalFilemaker
//
//  Created by iPHTech36 on 29/06/22.
//

import Cocoa

extension AppDelegate {
    
    //MARK: View Actions configuration.
    func configureViewMenu() {
        designMenuItem?.action  = #selector(handleViewMenuItemAction)
        presetMenuItem?.action  = nil
    }

    //MARK: Open Action Handler.
    @objc fileprivate func handleViewMenuItemAction(_ menuItem: NSMenuItem) {

        let openCloseStatus: Bool
        if menuItem == designMenuItem {
            openCloseStatus = true
            designMenuItem?.action  = nil
            presetMenuItem?.action  = #selector(handleViewMenuItemAction)
        }
        else {
            openCloseStatus = false
            designMenuItem?.action  = #selector(handleViewMenuItemAction)
            presetMenuItem?.action  = nil
        }

        if let window = NSApplication.shared.mainWindow?.windowController?.contentViewController as? ThreeDPortalViewController {
            window.designViewTap(openCloseStatus: openCloseStatus)
        }
        
    }
}
