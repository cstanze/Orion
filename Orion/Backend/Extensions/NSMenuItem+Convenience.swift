//
//  NSMenuItem+Convenience.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/31.
//

import Cocoa

extension NSMenuItem {
  /// Makes my life so much easier
  /// when I can just implement modifiers in one go
  convenience init(title string: String, target: AnyObject = self as AnyObject, action selector: Selector?, keyEquivalent charCode: String, modifier: NSEvent.ModifierFlags = .command) {
    self.init(title: string, action: selector, keyEquivalent: charCode)
    keyEquivalentModifierMask = modifier
    self.target = target
  }
  
  convenience init(title string: String, submenuItems: [NSMenuItem]) {
    self.init(title: string, action: nil, keyEquivalent: "")
    self.submenu = NSMenu()
    self.submenu?.items = submenuItems
  }
}
