//
//  AppDelegate.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/15.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  /// Determines whether or not the AppDelegate should force
  /// termination when ``AppDelegate/applicationShouldTerminate(_:)`` is executed
  ///
  /// Ideally, it would be best *not* to use mutable
  /// statics due to any data races (if any should occur)
  /// but I'm not too concerned about that right now.
  static var shouldForceTermination = false
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1076, height: 678),
                          styleMask: [.miniaturizable, .closable, .resizable, .titled],
                          backing: .buffered,
                          defer: false)
    window.contentViewController = ViewController()
    
    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    if AppDelegate.shouldForceTermination {
      return .terminateNow
    }
    
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = "Are you sure you want to quit Orion?"
    alert.informativeText = "This would close (windowCount) window(s) containing (aggTabCount) tab(s)."
    
    let quitButton = alert.addButton(withTitle: "Quit")
    let cancelButton = alert.addButton(withTitle: "Cancel")
    
    quitButton.keyEquivalent = "\r"
    cancelButton.keyEquivalent = ""
    
    let response = alert.runModal()
    if response == .alertFirstButtonReturn {
      return .terminateNow
    }
    
    return .terminateCancel
  }
  
  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

}

