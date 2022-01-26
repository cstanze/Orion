//
//  OrionWindowController.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/24.
//

import Cocoa

class OrionWindowController: NSWindowController, NSWindowDelegate {

  /// A simple list of observers that wait for resize events on the current window.
  let resizeObservers: [OrionWindowResizeObserver] = []
  
  init() {
    super.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1076, height: 678),
                          styleMask: [.miniaturizable, .closable, .resizable, .titled],
                          backing: .buffered,
                          defer: false))
    self.window!.minSize = NSSize(width: 575, height: 250)
    self.window!.delegate = self
  }
  
  func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
    for resizeObserver in resizeObservers {
      resizeObserver.windowWillResize(toSize: frameSize)
    }
    
    return frameSize
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func showWindow(_ sender: Any?) {
    if let window = window {
      window.makeKeyAndOrderFront(sender)
      window.center()
    } else {
      
    }
  }
}
