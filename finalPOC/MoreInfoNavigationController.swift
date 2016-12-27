//
//  MoreInfoNavigationController.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/16/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

class MoreInfoNavigationController: UINavigationController {
    
    var delegateController : LockedTicketsCollectionViewController!
    
    var handingOver : Bool!
    
    var reselling : Bool!
    
    var stxCode : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let destinationVC = self.viewControllers.first as? MoreInfoViewController {
            destinationVC.delegate = delegateController
            destinationVC.handingOver = self.handingOver
            destinationVC.reselling = self.reselling
            destinationVC.stxCode = self.stxCode
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }*/
    

}
