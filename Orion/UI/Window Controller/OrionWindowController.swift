//
//  OrionWindowController.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/30.
//

import Cocoa

class OrionWindowController: NSWindowController, NSToolbarItemValidation {

  var tabCollectionController: OrionTabCollectionController!
  var mainViewController: OrionViewController!

  var segmentedNavigationControl: NSSegmentedControl!

  var titleObserver: NSKeyValueObservation!
  var backObserver: NSKeyValueObservation!
  var forwardObserver: NSKeyValueObservation!

  var resizeObservers: [OrionWindowResizeObserver] = []

  init() {
    // MARK: - Window Setup
    super.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1076, height: 678),
                                styleMask: [.miniaturizable, .closable, .resizable, .titled],
                                backing: .buffered,
                                defer: false))
    self.window?.minSize = NSSize(width: 575, height: 250)
    self.window?.delegate = self

    // MARK: - Controller Setup
    self.tabCollectionController = OrionTabCollectionController()
    self.mainViewController = OrionViewController()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
    for resizeObserver in resizeObservers {
      resizeObserver.windowWillResize(toSize: frameSize)
    }

    return frameSize
  }

  override func showWindow(_ sender: Any?) {
    // MARK: - Configure Window
    if let window = self.window {
      // MARK: - Toolbar
      let toolbar = NSToolbar(identifier: NSToolbar.Identifier.windowToolbarIdentifier)
      toolbar.delegate = self
      toolbar.allowsUserCustomization = true
      // TODO: fix weird double extension button bug
//      toolbar.autosavesConfiguration = true
      toolbar.displayMode = .iconOnly

      window.titleVisibility = .hidden

      // toolbar.showsBaselineSeparator = false
      /// `.unified` for macOS 10.13+ ?
      if #available(macOS 11.0, *) {
        window.toolbarStyle = .unified
      }

      window.toolbar = toolbar
      window.toolbar?.validateVisibleItems()

      // MARK: - Visual Effects
      let visualEffect = NSVisualEffectView()
      visualEffect.blendingMode = .behindWindow
      visualEffect.state = .followsWindowActiveState
      visualEffect.material = .dark
      window.contentView = visualEffect
      window.styleMask.insert(.fullSizeContentView)

      window.contentView = mainViewController.view
      window.contentView?.wantsLayer = true
      setupSegmentedNavigation()

      backObserver = mainViewController.currentWebView!.observeForChanges(\.canGoBack) { [unowned self] in
        segmentedNavigationControl.setEnabled(mainViewController.currentWebView!.canGoBack, forSegment: 0)
      }
      forwardObserver = mainViewController.currentWebView!.observeForChanges(\.canGoForward) { [unowned self] in
        segmentedNavigationControl.setEnabled(mainViewController.currentWebView!.canGoForward, forSegment: 1)
      }
      titleObserver = mainViewController.currentWebView!.observeForChanges(\.title) { [unowned self] in
        self.window?.title = mainViewController.currentWebView!.title!
      }

      mainViewController.currentWebView!.navigationDelegate = self

      NotificationCenter.default.addObserver(
        self,
        selector: #selector(controllerWebViewDidChange),
        name: NSNotification.Name.WebViewChanged,
        object: nil
      )

      window.makeKeyAndOrderFront(sender)
      window.center()
    } else {
      print("No window exists?")
    }
  }

  // MARK: - Segmented Navigation Control

  func setupSegmentedNavigation() {
    segmentedNavigationControl = NSSegmentedControl(images: [
      { () -> NSImage in
        if #available(macOS 11, *) {
          return NSImage(systemSymbolName: "chevron.left", accessibilityDescription: nil)!
        } else {
          return NSImage(named: NSImage.goBackTemplateName)!
        }
      }(),
      { () -> NSImage in
        if #available(macOS 11, *) {
          return NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)!
        } else {
          return NSImage(named: NSImage.goForwardTemplateName)!
        }
      }()
    ], trackingMode: .momentary, target: self, action: #selector(navigate(_:)))

    segmentedNavigationControl.segmentStyle = .separated
    for segmentIndex in 0..<segmentedNavigationControl.segmentCount {
      segmentedNavigationControl.setEnabled(false, forSegment: segmentIndex)
    }
  }

  // MARK: - Tab Switching Logic

  @objc func controllerWebViewDidChange() {
    mainViewController.currentWebView?.navigationDelegate = self
  }

  // MARK: - Toolbar Validation

  func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
    switch item.itemIdentifier {
    case .navigationItemIdentifier:
      if let currentWebView = mainViewController.currentWebView {
        // Yes, it's not the best practice, but it works for my purposes
        // since I know the values will never change.
        segmentedNavigationControl.setEnabled(currentWebView.canGoBack, forSegment: 0)
        segmentedNavigationControl.setEnabled(currentWebView.canGoForward, forSegment: 1)
      }

      return true
    default: return true
    }
  }

  // MARK: - Toolbar Selectors

  @objc func dummy() {}

  @objc func newTab(_ sender: NSToolbarItem) {
//    NotificationCenter.default.post(name: .NewTabCreated, object: nil)
  }

  /// Updates the navigator item
  /// Essentially, it shows/hides the forward/backward toolbar items
  /// when its valid to have these interactive elements.
  ///
  /// It uses `WKWebView.canGoBack` and `WKWebView.canGoForward` to determine
  /// when to hide/show the items.
  @objc func navigate(_ sender: NSSegmentedControl) {
    if let currentWebView = mainViewController.currentWebView {
      switch sender.selectedSegment {
      case 0:
        currentWebView.goBack()
      case 1:
        currentWebView.goForward()
      default:
        preconditionFailure()
      }
    }

    window?.toolbar?.items.first(where: { item in
      item.itemIdentifier == .navigationItemIdentifier
    })?.validate()
  }

  @objc func extensionDidActivate(_ ext: NSToolbarItem) {
    let popover = NSPopover()
    popover.show(relativeTo: window!.frame, of: window!.contentView!, preferredEdge: .minX)
  }

  @objc func reloadHandler(_ sender: NSToolbarItem) {
    if let currentWebView = mainViewController.currentWebView {
      if currentWebView.isLoading {
        delegate.stopReloadingCurrent()
      } else {
        delegate.reloadCurrent()
      }
    }
  }
}
