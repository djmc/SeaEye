//
//  SeaEyeIconController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 25/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeIconController: NSViewController {

    @IBOutlet weak var iconButton : NSButton!;
    var model = CircleCIModel()
    var hasViewedBuilds = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBarIcon()
        self.setupStyleNotificationObserver()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("alert:"),
            name: "SeaEyeAlert",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("setRedBuildIcon"),
            name: "SeaEyeRedBuild",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("setGreenBuildIcon"),
            name: "SeaEyeGreenBuild",
            object: nil
        )
    }
    
    func alert(notification: NSNotification) {
        if let errorMessage = notification.userInfo!["errorMessage"] as? String {
            var notification = NSUserNotification()
            notification.title = "SeaEye"
            notification.informativeText = errorMessage
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
        }
    }
    
    func setGreenBuildIcon() {
        if hasViewedBuilds {
            if (self.isDarkModeEnabled()) {
                iconButton.image = NSImage(named: "circleci-success-alt")
            } else {
                iconButton.image = NSImage(named: "circleci-success")
            }
        }
    }
    
    func setRedBuildIcon() {
        hasViewedBuilds = false
        if (self.isDarkModeEnabled()) {
            iconButton.image = NSImage(named: "circleci-failed-alt")
        } else {
            iconButton.image = NSImage(named: "circleci-failed")
        }
    }
    
    private func setupMenuBarIcon() {
        hasViewedBuilds = true
        if (self.isDarkModeEnabled()) {
            iconButton.image = NSImage(named: "circleci-normal-alt")
        } else {
            iconButton.image = NSImage(named: "circleci-normal")
        }
    }
    
    private func setupStyleNotificationObserver() {
        NSDistributedNotificationCenter.defaultCenter()
            .addObserver(
                self,
                selector: Selector("alternateIconStyle"),
                name: "AppleInterfaceThemeChangedNotification",
                object: nil
        )
    }
    
    private func isDarkModeEnabled() -> Bool {
        let dictionary  = NSUserDefaults.standardUserDefaults().persistentDomainForName(NSGlobalDomain);
        if let interfaceStyle = dictionary?["AppleInterfaceStyle"] as? NSString {
            return interfaceStyle.localizedCaseInsensitiveContainsString("dark")
        } else {
            return false
        }
    }
    
    func alternateIconStyle() {
        var currentImage = iconButton.image
        if let imageName = currentImage?.name() {
            var alternateImageName : NSString
            if imageName.hasSuffix("-alt") {
                alternateImageName = imageName.stringByReplacingOccurrencesOfString(
                    "-alt",
                    withString: "",
                    options: nil,
                    range: nil
                )
            } else {
                alternateImageName = imageName.stringByAppendingString("-alt")
            }
            iconButton.image = NSImage(named: alternateImageName)
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "SeaEyeOpenPopoverSegue" {
            self.setupMenuBarIcon()
            let popoverContoller = segue.destinationController as SeaEyePopoverController
            popoverContoller.model = self.model
        }
    }
}
