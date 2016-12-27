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
    
    @IBAction func pressEventsButton(_ sender: UIButton) {
        if !activeEvents {
            performTransitionBetweenViews("left")
            activeEvents = true
        }
    }
    
    @IBAction func pressAccountButton(_ sender: UIButton) {
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
    
    fileprivate var selectedEvent : Int = -1
    
    fileprivate let eventsArray : [String] = ["semiFinalEvent.png", "finalEvent.png"]
    
    fileprivate var possibleY : [[CGFloat]] = [[]]
    
    fileprivate var hasBeenUnlocked : Bool =  false
    
    @IBAction func unlockTickets(_ sender: UIStoryboardSegue) {
        self.areTicketsLocked = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsContainer.alpha = 1
        accountContainer.alpha = 0
        self.navigation.title = "Events"
        eventsButton.setImage(UIImage(named: "selectedEventsButton.png"), for: UIControlState())
        accountButton.setImage(UIImage(named: "unselectedAccountButton.png"), for: UIControlState())
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectEvent)))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !hasBeenUnlocked {
            if !areTicketsLocked {
                performSegue(withIdentifier: "showUnlockedTicket", sender: nil)
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func getEventHeight(_ index : Int) -> CGFloat{
        let image = UIImage(named : eventsArray[index])!
        let sizeRate : CGFloat = CGFloat(image.size.width/(self.eventsContainer.frame.size.width*0.80))
        return CGFloat((image.size.height)/sizeRate)
    }
    
    func performTransitionBetweenViews(_ side: String) {
        if side == "right" {
                self.eventsContainer.alpha = 0
                self.accountContainer.alpha = 1
                self.eventsButton.setImage(UIImage(named: "unselectedEventsButton.png"), for: UIControlState())
                self.accountButton.setImage(UIImage(named: "selectedAccountButton.png"), for: UIControlState())
                self.navigation.title = "Account"
        }
        
        else {
                self.eventsContainer.alpha = 1
                self.accountContainer.alpha = 0
                self.eventsButton.setImage(UIImage(named: "selectedEventsButton.png"), for: UIControlState())
                self.accountButton.setImage(UIImage(named: "unselectedAccountButton.png"), for: UIControlState())
                self.navigation.title = "Events"
        }
    }
    
    func selectEvent(_ sender: UITapGestureRecognizer) {
        if activeEvents {
            let touchedPoint : CGPoint = sender.location(ofTouch: 0, in: self.eventsContainer)
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
                        performSegue(withIdentifier: "eventSelected", sender: nil)
                    }
                    else {
                        performSegue(withIdentifier: "showUnlockedTicket", sender: nil)
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventSelected" {
            if let destinationVC = segue.destination as? LockedTicketsCollectionViewController {
                destinationVC.currentEvent = self.selectedEvent
            }
        }
        
    }
 

}
