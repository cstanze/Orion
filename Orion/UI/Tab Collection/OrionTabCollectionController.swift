//
//  OrionTabCollectionController.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/31.
//

import Cocoa

class OrionTabCollectionController: NSViewController, NSStackViewDelegate {

  private var tabs: [OrionTabButton] = []
  private var tabStack: NSStackView?
  private var tabTag = 0

  override func loadView() {
//    self.view = OrionViewResizable()
    self.view = NSView()
    self.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.view.widthAnchor.constraint(lessThanOrEqualToConstant: 10_000),
      self.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
      self.view.heightAnchor.constraint(equalToConstant: 29)
    ])

    self.tabStack = NSStackView()
    self.tabStack?.orientation = .horizontal
    self.tabStack?.distribution = .fillProportionally
    self.tabStack?.delegate = self
    self.tabStack?.spacing = 10
    self.tabStack?.translatesAutoresizingMaskIntoConstraints = false
    self.tabStack?.setFrameSize(NSSize(width: 0, height: 40))
//    self.tabStack?.autoresizingMask = [.width]
    self.view.addSubview(self.tabStack!)
    NSLayoutConstraint.activate([
//      self.tabStack!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//      self.tabStack!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//      self.tabStack!.topAnchor.constraint(equalTo: self.view.topAnchor),
//      self.tabStack!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.tabStack!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.tabStack!.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.625),
      self.tabStack!.heightAnchor.constraint(equalToConstant: 29)
    ])

//    for i in 1...5 {
//      let ntv = initialiseNewTabView()
//      if i == 1 {
//        ntv.isFocused = true
//      }
//    }
//    let ntv = initialiseNewTabView()
//    ntv.isFocused = true
  }

//  func initialiseNewTabView() -> OrionTabSearchField {
//    let newTabView = OrionTabSearchField()
//    newTabView.tag = tabTag
//    tabTag += 1
//    newTabView.translatesAutoresizingMaskIntoConstraints = false
//    newTabView.isEditable = true
//    newTabView.isSelectable = true
//
//    newTabView.isBordered = true
//    newTabView.isBezeled = true
//    newTabView.bezelStyle = .roundedBezel
//    newTabView.focusRingType = .exterior
//
//    newTabView.maximumNumberOfLines = 1
//    newTabView.placeholderString = "Search or enter website name"
//
//    newTabView.tabDelegate = self
//
//    tabs.append(newTabView)
//    self.tabStack?.addArrangedSubview(newTabView)
//    newTabView.initialiseConstraints()
//
//    return newTabView
//  }
}

extension OrionTabCollectionController: OrionTabButtonDelegate {
  func tabStackFrame() -> NSRect {
    self.tabStack!.frame
  }

  func backingFrame() -> NSRect {
    self.view.frame
  }

  func tabCount() -> Int {
    self.tabs.count
  }

  func didFocusTab(withView view: OrionTabButton) {
    for subview in self.tabStack!.subviews {
      if subview == view { continue }

      // TODO: Make this a bit more optimised
//      if let sv = subview as? OrionTabButton {
//        /// Unfocus all other tabs
//        sv.isFocused = false
//      }
    }
  }
}
