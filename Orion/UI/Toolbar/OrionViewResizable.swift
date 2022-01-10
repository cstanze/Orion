//
//  OrionViewResizable.swift
//  Orion
//
//  Created by Jules Amalie on 2022-01-09.
//

import Foundation
import Cocoa

/// The view that stretches the background of the tab item to allow it to be centered in
/// older operating systems but also to auto resize whenever needed as well
class OrionViewResizable: NSView, OrionWindowResizeObserver {

    /// A window that gets set to the view before the view gets
    /// added to the window to allow the view to iterate the toolbar items
    var beforeLoadWindow: NSWindow?

    /// The controlled width constraint that determines that width
    /// needed for the tab item
    var widthConstraint: NSLayoutConstraint?

    /// A swap variable for the new sizes to be implemented
    private var newSize: NSSize?

    /// Called by the window, alerts the ViewResizable to resize its
    /// constraints
    func windowWillResize(toSize: NSSize) {
        newSize = toSize
        updateCustomSizing()
    }

    /// Called by the `OrionWindowController`, this resizes the constraints for
    /// on this view corresponding to the amount of size the search field item
    /// should take up.
    @objc func updateCustomSizing() {
        if widthConstraint == nil {
            widthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: calculateWidth())
            NSLayoutConstraint.activate([
                widthConstraint!
            ])
        } else {
            widthConstraint?.constant = calculateWidth()
        }
    }

    /// Calculates the width for the view depending on where it is located in the
    /// toolbar and expands accordingly
    func calculateWidth() -> CGFloat {
        var window: NSWindow?
        window = self.window ?? beforeLoadWindow
        if let toolbar = window!.toolbar {
            let ourIndex = toolbar.items.firstIndex { item in
                item.view === self
            }
            if ourIndex != -1 {
                var occupiedWidth: CGFloat = 0.0
                for item in toolbar.items where item.view !== self {
                    if item.view != nil {
                        occupiedWidth += item.view!.frame.width
                    } else {
                        occupiedWidth += 42.0
                    }
                }
                let widthToRequest = (newSize!.width - occupiedWidth - 88.0) // Window buttons
                let newCoordinates = convert(
                    NSPoint(
                        x: window!.contentView!.frame.midX,
                        y: 0
                    ),
                    to: self
                )
                subviews[0].setFrameOrigin(NSPoint(
                    x: newCoordinates.x - subviews[0].frame.width - (subviews[0].frame.width / 4),
                    y: subviews[0].frame.origin.y
                ))
                return widthToRequest
            }
        }
        return 0.0
    }
}
