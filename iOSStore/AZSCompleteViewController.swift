//
//  AZSCompleteViewController.swift
//  iOSStore
//
//  Created by Adnan Zildzic on 4/27/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

import UIKit

class AZSCompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotToHomeClicked(sender: AnyObject) {
        self.navigationController!.popToRootViewControllerAnimated(true);
    }
}
