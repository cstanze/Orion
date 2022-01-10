//
//  ExtensionToolbarItem.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/03.
//

import Cocoa

class ExtensionToolbarItem: NSToolbarItem {
  var extensionManifest: MozExtManifest!
  
  override init(itemIdentifier: NSToolbarItem.Identifier) {
    super.init(itemIdentifier: itemIdentifier)
    
    let extName = itemIdentifier.rawValue.replacingOccurrences(of: "OrionExtension_", with: "")
    extensionManifest = (NSApp.delegate as! AppDelegate).extensionManager.extensionManifests[extName]!
    
    let icon = extensionManifest.extensionIcon()
    let itemView = NSButton(image: icon != nil ? icon! : NSImage(named: NSImage.actionTemplateName)!, target: nil, action: nil)
    itemView.bezelStyle = .texturedRounded
    itemView.isBordered = true
    
    self.view = NSView()
    self.view!.setFrameSize(NSSize(width: 32, height: 32))
    itemView.setFrameSize(NSSize(width: 32, height: 32))
    
    self.view!.addSubview(itemView)
  }
}
