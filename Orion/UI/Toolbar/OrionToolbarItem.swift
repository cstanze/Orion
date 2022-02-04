//
//  OrionToolbarItem.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/13.
//

import Cocoa

class OrionToolbarItem: NSToolbarItem {
  override func validate() {
    if let keyWindow = NSApp.keyWindow {
      if let windowController = keyWindow.windowController as? OrionWindowController {
        self.isEnabled = windowController.validateToolbarItem(self)
      }
    }

    self.isEnabled = true
  }
}
