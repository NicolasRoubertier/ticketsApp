//
//  MoreInfoViewController.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/16/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

protocol ControllerDismissalDelegate {
    func unblurView() -> Bool
}

class MoreInfoViewController: UIViewController {
    
    var delegate : ControllerDismissalDelegate!
    
    var handingOver : Bool!
    
    var reselling : Bool!
    
    var stxCode : String!

    @IBOutlet weak var handOverContainer: UIView!
    
    @IBOutlet weak var resaleContainer: UIView!
    
    @IBAction func closeController(_ sender: AnyObject) {
        if delegate.unblurView() {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handOverContainer.alpha = (self.handingOver)! ? 1.0 : 0.0
        self.resaleContainer.alpha = (self.reselling)! ? 1.0 : 0.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSTXCode" {
            if let destinationVC = segue.destination as? ResellCodeViewController {
                if (self.reselling)! {
                    destinationVC.label = self.stxCode
                }
            }
        }
    }
    

}
