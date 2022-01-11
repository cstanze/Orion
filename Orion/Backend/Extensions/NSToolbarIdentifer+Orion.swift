//
//  NSToolbarIdentifer+Orion.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/30.
//

import Cocoa

extension NSToolbarItem.Identifier {
  static let shareButtonItemIdentifier = NSToolbarItem.Identifier("OrionShareButtonItem")
  static let addTabButtonItemIdentifier = NSToolbarItem.Identifier("OrionAddTabButtonItem")
  static let reloadItemIdentifier = NSToolbarItem.Identifier("OrionReloadItem")
  static let tabCollectionItemIdentifier = NSToolbarItem.Identifier("OrionTabCollectionItem")

  static let navigationItemIdentifier = NSToolbarItem.Identifier("OrionNavigationItem")
  static let navigationBackwardItemIdentifier = NSToolbarItem.Identifier("OrionNavigationBackwardItem")
  static let navigationForwardItemIdentifier = NSToolbarItem.Identifier("OrionNavigationForwardItem")
}

extension NSToolbar.Identifier {
  static let windowToolbarIdentifier = NSToolbar.Identifier("OrionWindowToolbar")
}
