//
//  OrionMenu.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/31.
//

import Cocoa

class OrionMenu: NSMenu {
  private lazy var applicationName = ProcessInfo.processInfo.processName

  override init(title: String) {
    super.init(title: title)
    guard #available(macOS 10.14, *) else { return }

    let mainMenu = NSMenuItem()
    mainMenu.submenu = NSMenu(title: applicationName)
    mainMenu.submenu?.items = [
      NSMenuItem(
        title: "About \(applicationName)",
        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
        keyEquivalent: ""
      ),
      NSMenuItem.separator(),
      NSMenuItem(title: "Services", submenuItems: []),
      NSMenuItem.separator(),
      NSMenuItem(title: "Hide \(applicationName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"),
      NSMenuItem(
        title: "Hide Others",
        action: #selector(NSApplication.hideOtherApplications(_:)),
        keyEquivalent: "h",
        modifier: [.command, .option]
      ),
      NSMenuItem(title: "Show All", action: nil, keyEquivalent: ""),
      NSMenuItem.separator(),
      NSMenuItem(title: "Quit \(applicationName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    ]
    NSApp.servicesMenu = mainMenu.submenu?.items[2].submenu
    mainMenu.submenu?.items[6].isEnabled = false

    let fileMenu = NSMenuItem()
    fileMenu.submenu = NSMenu(title: "File")
    fileMenu.submenu?.items = [
      NSMenuItem(
        title: "New Window",
        action: #selector((NSApplication.shared.delegate! as? AppDelegate)!.newWindow),
        keyEquivalent: "n"
      ),
      NSMenuItem.separator(),
      NSMenuItem(
        title: "Close Window",
        action: #selector((NSApplication.shared.delegate! as? AppDelegate)!.closeCurrentWindow),
        keyEquivalent: "W"
      )
    ]

    let editMenu = NSMenuItem()
    editMenu.submenu = NSMenu(title: "Edit")
    editMenu.submenu?.items = [
      NSMenuItem(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z"),
      NSMenuItem(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z"),
      NSMenuItem.separator(),
      NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"),
      NSMenuItem(title: "Cut", action: #selector(NSText.copy(_:)), keyEquivalent: "c"),
      NSMenuItem(title: "Cut", action: #selector(NSText.paste(_:)), keyEquivalent: "v"),
      NSMenuItem.separator(),
      NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
    ]

    let viewMenu = NSMenuItem()
    viewMenu.submenu = NSMenu(title: "View")
    viewMenu.submenu?.items = [
      NSMenuItem(
        title: "Stop",
        action: #selector((NSApplication.shared.delegate! as? AppDelegate)!.stopReloadingCurrent),
        keyEquivalent: "."
      ),
      NSMenuItem(
        title: "Reload Page",
        action: #selector((NSApplication.shared.delegate! as? AppDelegate)!.reloadCurrent),
        keyEquivalent: "r"
      )
    ]

    let windowMenu = NSMenuItem()
    windowMenu.submenu = NSMenu(title: "Window")
    windowMenu.submenu?.items = [
      NSMenuItem(title: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m"),
      NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: ""),
      NSMenuItem.separator(),
      NSMenuItem(title: "Bring All to Front", action: #selector(NSApp.arrangeInFront(_:)), keyEquivalent: "")
    ]

    let helpMenu = NSMenuItem()
    helpMenu.submenu = NSMenu(title: "Help")
    NSApp.helpMenu = helpMenu.submenu

    items = [mainMenu, fileMenu, editMenu, viewMenu, windowMenu, helpMenu]
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
