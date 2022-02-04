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

  /**
   * Here are some equations:
   *
   * `0.5 * backingWidth - (tabCount - 1) * 80`
   * `(backingWidth) + (minimumWidth * tabCount)`
   */
  func calculated(backingFrame: NSRect, _ tabCount: Int = 1, _ focused: Bool = false) -> CGFloat {
    var calculatedWidth: CGFloat

    switch self {
    case .percentage(let percentage):
      calculatedWidth =  backingFrame.width * (percentage / 100)
    case .growing(let minimum, let maximum):
      // Despite this not being used by single tabs, this should stay here.
      calculatedWidth = tabCount > 1 ? maximum : minimum
      guard tabCount > 1 else { return calculatedWidth }

      if focused {
        calculatedWidth = 0.5 * backingFrame.width - CGFloat(tabCount - 1) * 80
      } else {
        calculatedWidth = backingFrame.width + (minimum * CGFloat(tabCount))
      }
    }

    return calculatedWidth
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
      guard delegate != nil else { return false }

      return delegate!.tabStackFrame().minX == 0 && delegate!.backingFrame().width == delegate!.tabStackFrame().width
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)

  }

  private func calculateSize() -> NSSize? {
    var size = NSSize(width: 0, height: 29)

    if let delegate = delegate {
      var calculatedWidth: CGFloat
      if delegate.tabCount() == 1 {
        calculatedWidth = TabWidth.natural.calculated(backingFrame: delegate.backingFrame(), delegate.tabCount(), _isFocused)
      } else {
        calculatedWidth = TabWidth.multiple.calculated(backingFrame: delegate.backingFrame(), delegate.tabCount(), _isFocused)
      }

      size.width = calculatedWidth
    }

    return size
  }

}
