//
//  SeaEyeSettingsController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 26/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeSettingsController: NSViewController {
    
    var parent : SeaEyePopoverController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func openAPIPage(sender: NSButton) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://circleci.com/account/api")!)
    }
    
    @IBAction func saveUserData(sender: NSButton) {
        parent.openBuilds(sender)
    }
    
}