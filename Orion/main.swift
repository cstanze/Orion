//
//  main.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/15.
//

import Cocoa

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
NSApplication.shared.menu = NSMenu()
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
