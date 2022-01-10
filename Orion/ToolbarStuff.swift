//
//  OrionWindowController+NSToolbarDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//

import Foundation
import Cocoa

/// Because we are using an extension we can't have non-static members, so we need
/// to implement an external cache of sorts to not have to pollute the stack with objects
var cachedToolbarItems: [NSToolbarItem.Identifier: NSToolbarItem]?

private extension NSToolbarItem.Identifier {
    static let addTab: NSToolbarItem.Identifier = NSToolbarItem.Identifier("AddTab")
    static let goBack: NSToolbarItem.Identifier = NSToolbarItem.Identifier("GoBack")
    static let goForward: NSToolbarItem.Identifier = NSToolbarItem.Identifier("GoForward")
    static let reload: NSToolbarItem.Identifier = NSToolbarItem.Identifier("Reload")
    static let addBookmark: NSToolbarItem.Identifier = NSToolbarItem.Identifier("AddBookmark")
    static let pinTab: NSToolbarItem.Identifier = NSToolbarItem.Identifier("PinTab")
    static let tabs: NSToolbarItem.Identifier = NSToolbarItem.Identifier("Address")
}

/// This implemlents the toolbar functionality of the application
/// or connects the dots
extension OrionWindowController {
    
    static let allItemIdentifiers: [NSToolbarItem.Identifier] = [
        NSToolbarItem.Identifier.addTab,
        NSToolbarItem.Identifier.goBack,
        NSToolbarItem.Identifier.goForward,
        NSToolbarItem.Identifier.reload,
        NSToolbarItem.Identifier.tabs,
        NSToolbarItem.Identifier.flexibleSpace,
    ]
    
    // TODO: Figure out if this needs to be in order
    static let allDefaultItemIdentifiers: [NSToolbarItem.Identifier] = [
        NSToolbarItem.Identifier.goBack,
        NSToolbarItem.Identifier.goForward,
        NSToolbarItem.Identifier.flexibleSpace,
        NSToolbarItem.Identifier.tabs,
        NSToolbarItem.Identifier.flexibleSpace,
        NSToolbarItem.Identifier.addTab,
    ]
    
    static let toolbarItemNames: [NSToolbarItem.Identifier: String] = [
        NSToolbarItem.Identifier.addTab: "New Tab",
        NSToolbarItem.Identifier.goBack: "Go Back",
        NSToolbarItem.Identifier.goForward: "Go Forward",
        NSToolbarItem.Identifier.reload: "Refresh",
        NSToolbarItem.Identifier.tabs: "Address, Search, and tabs",
        NSToolbarItem.Identifier.flexibleSpace: "",
    ]
//    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return OrionWindowController.allItemIdentifiers
//    }
//
//    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return OrionWindowController.allDefaultItemIdentifiers
//    }
    
//    func configureItem(
//        _ identifier: NSToolbarItem.Identifier,
//        _ imageName: NSImage.Name,
//        _ action: Selector
//    ) -> NSToolbarItem {
//        let item: NSToolbarItem = NSToolbarItem(itemIdentifier: identifier)
//        if identifier != NSToolbarItem.Identifier.tabs {
//            let barButton = NSButton(image: NSImage(named: imageName)!, target: self, action: action)
//            barButton.isBordered = false
//            NSLayoutConstraint.activate([
//                barButton.heightAnchor.constraint(equalToConstant: 25),
//                barButton.widthAnchor.constraint(equalToConstant: 29)
//            ])
//            item.view = barButton
//        }
//        if OrionWindowController.toolbarItemNames.keys.contains(identifier) {
//            item.paletteLabel = OrionWindowController.toolbarItemNames[identifier]!
//        }
//        return item
//    }
    
//    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
//        // Custom default items
//        var defaultItems: [NSToolbarItem.Identifier: NSToolbarItem] {
//            if cachedToolbarItems != nil {
//                return cachedToolbarItems!
//            }
//
//            let toolbarItems = [
//                configureItem(NSToolbarItem.Identifier.addTab, NSImage.addTemplateName, #selector(newTab(sender:))),
//                configureItem(NSToolbarItem.Identifier.goBack, NSImage.goBackTemplateName, #selector(navigate(sender:))),
//                configureItem(NSToolbarItem.Identifier.goForward, NSImage.goForwardTemplateName, #selector(navigate(sender:))),
//                configureItem(NSToolbarItem.Identifier.reload, NSImage.refreshTemplateName, #selector(reloadPage(sender:))),
//                configureItem(NSToolbarItem.Identifier.tabs, "", #selector(unimplementedAction(sender:))), // This should never be called
//                NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.flexibleSpace),
//            ]
//
//            let mapped = Dictionary(uniqueKeysWithValues: toolbarItems.map { item in
//                return (item.itemIdentifier, item)
//            })
//
//            cachedToolbarItems = mapped
//            return cachedToolbarItems!
//        }
//
//        if defaultItems.keys.contains(itemIdentifier) {
//            return defaultItems[itemIdentifier]
//        } else {
//            // TODO: Get the "How did we get here" acheivement
//            return nil
//        }
//    }
    
    // MARK: NSToolbarItem actions
    
    @objc func unimplementedAction(sender: NSToolbarItem) {
        print("[*] WARNING: Action unimplemented on item: \(sender.itemIdentifier.rawValue)")
    }
    
    @objc func reloadPage(sender: NSToolbarItem) {
        
    }
    
}
