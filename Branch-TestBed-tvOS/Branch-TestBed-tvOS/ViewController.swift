//
//  ViewController.swift
//  Branch-TestBed-tvOS
//
//  Created by Ernest Cho on 5/27/20.
//  Copyright © 2020 Branch Metrics, Inc. All rights reserved.
//

import UIKit
import Branch

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.shared().registerLogBlock { [weak self] (message) in
            DispatchQueue.main.async {
                if let label = self?.textLabel {
                    label.text = message
                }
            }
        }
    }
    
    // self click a URI
    @IBAction func testURI() {
        if let url = URL(string:"branchtest://selflink") {
            if #available(tvOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    if (success == false) {
                        Logger.shared().log("Failed to self link: " + url.absoluteString)
                    }
                }
            } else {
                // tvOS 9 openURL
                let success = UIApplication.shared.openURL(url)
                if (success == false) {
                    Logger.shared().log("Failed to self link: " + url.absoluteString)
                }
            }
        }
    }
    
    // self click a Branch Link
    @IBAction func testBranchLink() {
        if let url = URL(string:"https://bnctestbed.app.link/cCWdYYokQ6?$source=selflink") {
            self.openURL(url: url)
        }
    }
    
    // workaround for self linking with universal links
    // normally, apps don't link to themselves with a universal link
    // https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html
    func openURL(url:URL) {
        
        // directly call continueUserActivity with a reasonable activity type
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = url
        let success = UIApplication.shared.delegate?.application?(UIApplication.shared, continue: userActivity, restorationHandler: { (activities) in
            // do nothing on restore
        })
        
        // success here does not indicate that the link will work as a universal link
        if (success == false) {
            Logger.shared().log("Failed to self link: " + url.absoluteString)
        }
    }
    
    // create an event
    @IBAction func testEvent() {
        let event = BranchEvent.standardEvent(BranchStandardEvent.purchase)
        event.logEvent { (success, error) in
            if let message = error?.localizedDescription {
                Logger.shared().log(message)
            } else {
                Logger.shared().log("logEvent success")
            }
        }
    }
    
    // create a short link
    @IBAction func testCreateLink() {
        let url = Branch.getInstance().getShortURL()
        Logger.shared().log(url)
    }
}

