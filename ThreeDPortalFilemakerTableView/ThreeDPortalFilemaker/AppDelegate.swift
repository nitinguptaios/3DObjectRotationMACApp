//
//  AppDelegate.swift
//  ThreeDPortalFilemaker
//
//  Created by iPHTech36 on 23/06/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var openMenuItem: NSMenuItem?
    @IBOutlet weak var designMenuItem: NSMenuItem?
    @IBOutlet weak var presetMenuItem: NSMenuItem?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

extension AppDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureOpenMenu()
    }

}
