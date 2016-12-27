//
//  ResellCodeViewController.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/17/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

class ResellCodeViewController: UIViewController {
    
    @IBOutlet weak var stxCode: UILabel!
    
    var label : String!

    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stxCode.text = self.label
        self.view.addConstraint(NSLayoutConstraint(item: self.infoLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: self.view.frame.size.width*0.08))
        self.infoLabel.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addConstraint(NSLayoutConstraint(item: self.infoLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.size.width*0.84))
        self.infoLabel.numberOfLines = 2
        self.infoLabel.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        print(self.infoLabel.font)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
