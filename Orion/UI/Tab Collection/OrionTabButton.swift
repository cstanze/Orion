//
//  OrionTabButton.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/09.
//

import Cocoa

private enum TabButtonWidth {
  /// Calculated using the percentage of the backing view (highest view in the tab collection)
  case percentage(CGFloat)
  
  /// The raw value (but allows for growth using the tab size equation)
  case growing(CGFloat, CGFloat)
  
  func calculated(backingFrame: NSRect, _ single: Bool = false) -> CGFloat {
    let calculatedWidth: CGFloat
    
    switch self {
    case .percentage(let percentage):
      calculatedWidth =  backingFrame.width * (percentage / 100)
    case .growing(let minimum, let maximum):
      calculatedWidth = 0
    }
    
    guard !single else { return calculatedWidth }
    
    return 0
  }
}

class OrionTabButton: NSView {
  
  private struct TabWidth {
    /// `.natural` represents a maximum width when there is one tab
    static let natural: TabButtonWidth = .percentage(62.5)
    
    /// `.multiple` represents a maximum width when there are multiple tabs
    static let multiple: TabButtonWidth = .growing(32, 148)
  }

  weak var delegate: OrionTabButtonDelegate?

  private var _isFocused = false
  var isFocused: Bool {
    get {
      return _isFocused
    }
    
    set {
      _isFocused = newValue
    }
  }
  
  private var shouldSqueezeTabs: Bool {
    get {
      guard delegate != nil else { return false }
      
      return delegate!.tabStackFrame().minX == 0 && delegate!.backingFrame().width == delegate!.tabStackFrame().width
    }
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)

    
  }
  
  private func calculateSize() -> NSSize? {
    var size = NSSize(width: 0, height: 29)
    
    if let delegate = delegate {
      var calculatedWidth: TabButtonWidth
      if delegate.tabCount() == 1 {
        calculatedWidth = TabWidth.natural
      } else if _isFocused {
        calculatedWidth = TabWidth.natural
      }
    }
    
    return size
  }
    
}
