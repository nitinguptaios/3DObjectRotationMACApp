//
//  OpenMenuExtension.swift
//  ThreeDPortalFilemaker
//
//  Created by iPHTech36 on 24/06/22.
//

import Cocoa

extension AppDelegate {
    
    //MARK: Open Action configuration.
    func configureOpenMenu() {
        openMenuItem?.action  = #selector(handleOpenMenuItemAction)
    }
    
    //MARK: Open Action Handler.
    @objc fileprivate func handleOpenMenuItemAction(_ menuItem: NSMenuItem) {

        let dialog = NSOpenPanel()
        dialog.title = "Choose multiple files"
        dialog.allowedFileTypes = ["stl", "ply"]
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = true
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let results = dialog.urls // Results contains an array with all the selected paths
            if let window = NSApplication.shared.mainWindow?.windowController?.contentViewController as? ThreeDPortalViewController {
                window.load3DModel(path: results.map({$0.path}))
            }
        } else {
            
            return
        }
    }
}
