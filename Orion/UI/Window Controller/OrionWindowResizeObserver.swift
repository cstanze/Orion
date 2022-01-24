//
//  OrionWindowResizeObserver.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/24.
//

import Foundation

protocol OrionWindowResizeObserver: AnyObject {
  func windowWillResize(toSize size: NSSize)
}
