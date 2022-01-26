//
//  OrionWindowResizeObserver.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/24.
//

import Foundation

/// A protocol for objects to inherit if they want to opt-in to window resize events.
protocol OrionWindowResizeObserver: AnyObject {
  func windowWillResize(toSize size: NSSize)
}
