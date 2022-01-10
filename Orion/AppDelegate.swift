//
//  AppDelegate.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/30.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
  
  private var windowControllers: [OrionWindowController] = []
  var extensionManager = OrionExtensionManager()
  var affinityManager = OrionSiteAffinityManager()

  func applicationDidFinishLaunching(_ finishLaunching: Notification) {
    /// How would this even trigger? Who knows. It's possible though. -_-
    guard FileManager.default.applicationSupportUrl != nil else {
      let window = NSWindow(contentRect: NSMakeRect(0, 0, 1076, 678),
                                  styleMask: [.miniaturizable, .closable, .resizable, .titled],
                                  backing: .buffered,
                                  defer: false)
      window.makeKeyAndOrderFront(nil)
      
      let failedAlert = NSAlert()
      failedAlert.messageText = "Failed to create Application Support folder."
      failedAlert.informativeText = "Check for any errors or contact support. Otherwise, please try again."
      failedAlert.addButton(withTitle: "Ok")
      failedAlert.runModal()
      
      NSApp.terminate(nil)
      return
    }
    print("Found Application Support: \(FileManager.default.applicationSupportUrl!.path)")
    _ = self.newWindow()
  }
  
  @objc func reloadCurrent() {
    if let windowController = NSApp.keyWindow?.windowController as? OrionWindowController {
      windowController.mainViewController.currentWebView?.reload()
    }
  }
  
  @objc func stopReloadingCurrent() {
    if let windowController = NSApp.keyWindow?.windowController as? OrionWindowController {
      if let currentWebView = windowController.mainViewController.currentWebView {
        if currentWebView.isLoading {
          currentWebView.stopLoading()
        }
      }
    }
  }
  
  @objc func newWindow() -> OrionWindowController {
    let newController = OrionWindowController()
    windowControllers.append(newController)
    newController.showWindow(self)
    
    return newController
  }
  
  @objc func closeCurrentWindow() {
    NSApplication.shared.keyWindow?.close()
  }

  func applicationWillTerminate(_ willTerminate: Notification) {
    // TODO: write some teardown code here...
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

