//
//  OrionWindowController+NSToolbarDelegate.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/30.
//

import Cocoa

/// Makes things easier for me, no need to recreate toolbar items everytime
/// Are globals bad in Swift?
/// Or just C/C++?
var toolbarItemCache: [NSToolbarItem.Identifier: NSToolbarItem]?

extension OrionWindowController: NSToolbarDelegate {
  
  // MARK: - Allowed Items
  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [
      .navigationItemIdentifier,
      .addTabButtonItemIdentifier,
      .shareButtonItemIdentifier,
      .flexibleSpace,
      .tabCollectionItemIdentifier,
      .reloadItemIdentifier
    ]
  }
  
  // MARK: - Default Items
  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [
      .navigationItemIdentifier,
      .tabCollectionItemIdentifier,
      .shareButtonItemIdentifier,
      .reloadItemIdentifier,
      .addTabButtonItemIdentifier,
    ]
  }
  
  // MARK: - Creating Toolbar Items
  func newToolbarItem(withIdentifier identifier: NSToolbarItem.Identifier, name: String, image: String, sfImage: String, _ action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: identifier)
    
    if identifier != .tabCollectionItemIdentifier && identifier != .navigationItemIdentifier {
      /// The tab collection is going to be configured
      /// with `item.view`
      if #available(macOS 11, *) {
        toolbarItem.image = NSImage(systemSymbolName: sfImage, accessibilityDescription: nil)
      } else {
        toolbarItem.image = NSImage(named: image)
      }
      toolbarItem.target = self
      toolbarItem.action = action
      if #available(macOS 10.15, *) {
        toolbarItem.isBordered = true
      }
    } else {
      if identifier == .tabCollectionItemIdentifier {
        toolbarItem.view = self.tabCollectionController?.view
        self.resizeObservers.append(self.tabCollectionController?.view)
      } else {
        toolbarItem.view = NSStackView()
        toolbarItem.target = self
        toolbarItem.view?.setFrameSize(NSSize(width: 64, height: 32))
        
        let backwardItem = NSButton()
        backwardItem.bezelStyle = .texturedRounded
        backwardItem.target = self
        backwardItem.action = action
        backwardItem.setFrameSize(NSSize(width: 32, height: 32))
        
        let forwardItem = NSButton()
        forwardItem.bezelStyle = .texturedRounded
        forwardItem.target = self
        forwardItem.action = action
        forwardItem.setFrameSize(NSSize(width: 32, height: 32))
        forwardItem.setFrameOrigin(NSPoint(x: 32, y: 0))
        
        if #available(macOS 11, *) {
          backwardItem.image = NSImage(systemSymbolName: "chevron.backward", accessibilityDescription: nil)
          forwardItem.image = NSImage(systemSymbolName: "chevron.forward", accessibilityDescription: nil)
        } else {
          backwardItem.image = NSImage(named: NSImage.goBackTemplateName)
          forwardItem.image = NSImage(named: NSImage.goForwardTemplateName)
        }
        
        backwardItem.image?.size = NSSize(width: 32, height: 32)
        forwardItem.image?.size = NSSize(width: 32, height: 32)
        
        if #available(macOS 10.15, *) {
          backwardItem.isBordered = true
          forwardItem.isBordered = true
        }
        
        toolbarItem.view?.addSubview(backwardItem)
        toolbarItem.view?.addSubview(forwardItem)
        
        backNavigationControl = backwardItem
        forwardNavigationControl = forwardItem
      }
    }
    
    toolbarItem.label = name
    toolbarItem.paletteLabel = name
    
    return toolbarItem
  }
  
  // MARK: - Toolbar Item Insertion
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    var defaultItems: [NSToolbarItem.Identifier: NSToolbarItem] {
      if let toolbarItemCache = toolbarItemCache {
        return toolbarItemCache
      }
      
      let items = [
        newToolbarItem(
          withIdentifier: .navigationItemIdentifier,
          name: "Back/Forward",
          image: NSImage.touchBarTextStrikethroughTemplateName,
          sfImage: "strikethrough",
          #selector(navigate(_:))
        ),
        newToolbarItem(
          withIdentifier: .tabCollectionItemIdentifier,
          name: "Address, Search, and Tabs",
          image: NSImage.lockUnlockedTemplateName,
          sfImage: "lock.open",
          #selector(dummy)
        ),
        newToolbarItem(
          withIdentifier: .reloadItemIdentifier,
          name: "Reload Tab",
          image: NSImage.refreshTemplateName,
          sfImage: "arrow.clockwise",
          #selector(reloadHandler(_:))
        ),
        newToolbarItem(
          withIdentifier: .addTabButtonItemIdentifier,
          name: "New Tab",
          image: NSImage.addTemplateName,
          sfImage: "plus",
          #selector(newTab(_:))
        )
      ]
      
      let mappedCacheItems = Dictionary(uniqueKeysWithValues: items.map { item in
        return (item.itemIdentifier, item)
      })
      
      toolbarItemCache = mappedCacheItems
      return toolbarItemCache ?? [:]
    }
    
    if defaultItems.keys.contains(itemIdentifier) {
      return defaultItems[itemIdentifier]
    } else if itemIdentifier.rawValue.starts(with: "OrionExtension_") {
      let item = ExtensionToolbarItem(itemIdentifier: itemIdentifier)
      (item.view!.subviews[0] as! NSButton).target = self
      (item.view!.subviews[0] as! NSButton).action = #selector(extensionDidActivate(_:))
      
      return item
    }
    
    return nil
  }
}
