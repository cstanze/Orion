//
//  OrionTabButtonDelegate.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/06.
//

import Foundation

protocol OrionTabButtonDelegate: AnyObject {
  /// When a tab is focused, this is executed by the currently focused tab
  func didFocusTab(withView view: OrionTabButton)
  
  /// When a tab constraints are calculated, this is executed
  func tabCount() -> Int
  
  /// Returns the frame of the tab collection stack
  func tabStackFrame() -> NSRect
  
  /// Returns the frame of the backing view
  func backingFrame() -> NSRect
}
