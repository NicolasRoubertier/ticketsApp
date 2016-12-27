//
//  MainViewController.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/9/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var eventsButton: UIButton!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBAction func pressEventsButton(sender: UIButton) {
        if !activeEvents {
            performTransitionBetweenViews("left")
            activeEvents = true
        }
    }
    
    @IBAction func pressAccountButton(sender: UIButton) {
        if activeEvents {
            performTransitionBetweenViews("right")
            activeEvents = false
        }
    }
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var eventsContainer: UIView!
    
    @IBOutlet weak var accountContainer: UIView!
    
    var activeEvents : Bool = true
    
    var areTicketsLocked : Bool = true
    
    private var selectedEvent : Int = -1
    
    private let eventsArray : [String] = ["semiFinalEvent.png", "finalEvent.png"]
    
    private var possibleY : [[CGFloat]] = [[]]
    
    private var hasBeenUnlocked : Bool =  false
    
    @IBAction func unlockTickets(sender: UIStoryboardSegue) {
        self.areTicketsLocked = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsContainer.alpha = 1
        accountContainer.alpha = 0
        self.navigation.title = "Events"
        eventsButton.setImage(UIImage(named: "selectedEventsButton.png"), forState: .Normal)
        accountButton.setImage(UIImage(named: "unselectedAccountButton.png"), forState: .Normal)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectEvent)))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if !hasBeenUnlocked {
            if !areTicketsLocked {
                performSegueWithIdentifier("showUnlockedTicket", sender: nil)
                hasBeenUnlocked = true
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        possibleY = {
            let minY : CGFloat = self.eventsContainer.frame.size.height*0.08
            let nbOfCells : Int = eventsArray.count
            var res : [[CGFloat]] = [[CGFloat]]()
            for event in 0 ..< nbOfCells {
                let lowerY : CGFloat = minY + CGFloat(event)*(getEventHeight(event)+50.0)
                let upperY : CGFloat = lowerY + getEventHeight(event)
                res.append([lowerY, upperY])
            }
            return res
        }()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func getEventHeight(index : Int) -> CGFloat{
        let image = UIImage(named : eventsArray[index])!
        let sizeRate : CGFloat = CGFloat(image.size.width/(self.eventsContainer.frame.size.width*0.80))
        return CGFloat((image.size.height)/sizeRate)
    }
    
    func performTransitionBetweenViews(side: String) {
        if side == "right" {
                self.eventsContainer.alpha = 0
                self.accountContainer.alpha = 1
                self.eventsButton.setImage(UIImage(named: "unselectedEventsButton.png"), forState: .Normal)
                self.accountButton.setImage(UIImage(named: "selectedAccountButton.png"), forState: .Normal)
                self.navigation.title = "Account"
        }
        
        else {
                self.eventsContainer.alpha = 1
                self.accountContainer.alpha = 0
                self.eventsButton.setImage(UIImage(named: "selectedEventsButton.png"), forState: .Normal)
                self.accountButton.setImage(UIImage(named: "unselectedAccountButton.png"), forState: .Normal)
                self.navigation.title = "Events"
        }
    }
    
    func selectEvent(sender: UITapGestureRecognizer) {
        if activeEvents {
            let touchedPoint : CGPoint = sender.locationOfTouch(0, inView: self.eventsContainer)
            if self.eventsContainer.frame.size.width*0.1...self.eventsContainer.frame.size.width*0.90 ~= touchedPoint.x {
                var selectedCellIndex : Int = -1
                var index = 0
                repeat {
                    if possibleY[index][0]...possibleY[index][1] ~= touchedPoint.y {
                        selectedCellIndex = index
                    }
                    index += 1
                }while(selectedCellIndex == -1 && index < eventsArray.count)
                if selectedCellIndex >= 0 {
                    self.selectedEvent = selectedCellIndex
                    if(areTicketsLocked) {
                        performSegueWithIdentifier("eventSelected", sender: nil)
                    }
                    else {
                        performSegueWithIdentifier("showUnlockedTicket", sender: nil)
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eventSelected" {
            if let destinationVC = segue.destinationViewController as? LockedTicketsCollectionViewController {
                destinationVC.currentEvent = self.selectedEvent
            }
        }
        
    }
 

}
