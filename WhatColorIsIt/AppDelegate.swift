//
//  AppDelegate.swift
//  WhatColorIsIt
//
//  Created by Chris Slowik on 4/5/16.
//  Copyright © 2016 Chris Slowik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    var timer: NSTimer!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.menu = statusMenu
        updateTime()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        timer.invalidate()
        NSApplication.sharedApplication().terminate(self)
    }
    
    func updateTime() {
        statusItem.image = NSImage.whatColor()
    }

}

extension NSColor {
    class func fromTime() -> NSColor {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        let rd = CGFloat(components.hour) / 24
        let grn = CGFloat(components.minute) / 60
        let bl = CGFloat(components.second) / 60
        return NSColor(red: rd, green: grn, blue: bl, alpha: 1)
    }
}

extension NSImage {
    class func whatColor() -> NSImage {
        let theIcon = NSImage(size: NSSize(width: 16, height: 16))
        theIcon.lockFocus()
        let iconPath = NSBezierPath(roundedRect: NSMakeRect(0, 0, 14, 14), xRadius: 3, yRadius: 3)
        NSColor.fromTime().setFill()
        NSColor(red:0.133, green:0.152, blue:0.182, alpha:0.5).setStroke()
        iconPath.fill()
        iconPath.stroke()
        theIcon.unlockFocus()
        return theIcon
    }
}