//
//  LockedTicketsCollectionViewController.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/10/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

private let reuseIdentifier = "lockedTicketCell"

extension LockedTicketsCollectionViewController : ControllerDismissalDelegate {
    func unblurView() -> Bool {
        var res : Bool = false
        if let blurView = self.view.subviews[self.view.subviews.count - 1] as? UIVisualEffectView {
            res = !res
            blurView.removeFromSuperview()
        }
        return res
    }
}

extension LockedTicketsCollectionViewController : LockedTicketsLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        let image = UIImage(named: data[currentEvent]![indexPath.row])!
        let sizeRate : CGFloat = CGFloat(image.size.width/(self.collectionView!.frame.size.width))
        return CGFloat((image.size.height)/sizeRate)
    }
    
    func widthOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat {
        return self.collectionView!.frame.size.width
    }
    
    func yOffsetOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat {
        return self.collectionView!.frame.size.height*0.05
    }
    
    func shouldDisplayCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> Bool {
        return self.toDisplay[self.getCurrentEvent(collectionView)]![indexPath.row]
    }
    
    func getCurrentEvent(collectionView: UICollectionView) -> Int {
        return (self.currentEvent)!
    }
}

class LockedTicketsCollectionViewController: UICollectionViewController {
    
    private let data : [Int:[String]] = [0:["lockedTicket.png", "moreInfo.png", "lockedTicket2.png", "moreInfo.png"], 1:[]]
    
    private let stxCodes : [Int:[String]] = [0:["dzg7ui8Jsrs3", "sj7dczUi62id"], 1:[]]
    
    private var toDisplay : [Int:[Bool]] = [0:[true,false,true,false], 1:[]]
    
    var currentEvent : Int!
    
    var imageContainer :  UIImageView!
    
    var infoOverView : UIView!
    
    @IBAction func clickUnlockButton(sender: AnyObject) {
        self.imageContainer.alpha = 1.0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3*NSEC_PER_SEC)), dispatch_get_main_queue(),{self.performSegueWithIdentifier("goBackAfterUnlocking", sender: nil)})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageContainer = UIImageView(frame: CGRect(origin: CGPoint(x:self.collectionView!.frame.origin.x+self.collectionView!.frame.size.width*0.225, y:self.collectionView!.frame.origin.y+self.collectionView!.frame.size.height*0.13), size: CGSize(width: self.collectionView!.frame.size.width*0.55, height: self.collectionView!.frame.size.height*0.54)))
        if let layout = collectionView?.collectionViewLayout as? LockedTicketsCollectionViewLayout {
            layout.delegate = self
        }
        let imagesArray : [UIImage] = {
            var res : [UIImage] = [UIImage]()
            for i in 2...12 where i%2==0 {
                let image = UIImage(named: "loading\(i).png")!
                res.append(image)
            }
            return res
        }()
        imageContainer.animationImages = imagesArray
        imageContainer.animationDuration = 0.9
        imageContainer.startAnimating()
        imageContainer.contentMode = UIViewContentMode.ScaleAspectFit
        self.collectionView!.addSubview(imageContainer)
        self.collectionView!.bringSubviewToFront(imageContainer)
        imageContainer.alpha = 0.0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLockedTicket)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (data[currentEvent]?.count)!
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LockedTicketsCollectionViewCell
        
        cell.lockedTicketImageView.image = UIImage(named: data[currentEvent]![indexPath.row])!
        cell.lockedTicketImageView.contentMode = UIViewContentMode.ScaleAspectFit
    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (self.collectionView!.cellForItemAtIndexPath(indexPath) as? LockedTicketsCollectionViewCell) != nil {
            if indexPath.row%2==0 {
                self.toDisplay[self.currentEvent]![indexPath.row+1] = !(self.toDisplay[self.currentEvent]![indexPath.row+1])
                if let layout = self.collectionView!.collectionViewLayout as? LockedTicketsCollectionViewLayout {
                    layout.isBeingReloaded = true
                }
                self.collectionView!.reloadData()
            }
        }
    }
    
    func selectLockedTicket(sender: UITapGestureRecognizer) {
        let indexPath : NSIndexPath = self.collectionView!.indexPathForItemAtPoint(sender.locationOfTouch(0, inView: self.collectionView!))!
        let location = sender.locationOfTouch(0, inView: self.collectionView!)
        if indexPath.row%2 == 1 {
            let cellOrigin = self.collectionView!.cellForItemAtIndexPath(indexPath)!.frame.origin
            let cellWidth = self.widthOfTicketsOfCollectionView(self.collectionView!)
            let cellHeight = self.collectionView(self.collectionView!, heightOfCellAtIndexPath: indexPath)
            if (cellWidth*0.335...cellWidth*0.594 ~= (location.x - cellOrigin.x)) || (cellWidth*0.679...cellWidth*0.937 ~= (location.x - cellOrigin.x)) {
                if cellHeight*0.71...cellHeight*0.915 ~= (location.y - cellOrigin.y) {
                    if let vc = storyboard!.instantiateViewControllerWithIdentifier("moreInfoController") as? MoreInfoNavigationController {
                        vc.reselling = (cellWidth*0.335...cellWidth*0.594 ~= (location.x - cellOrigin.x))
                        vc.handingOver = !vc.reselling
                        vc.delegateController = self
                        vc.stxCode = stxCodes[self.currentEvent]![(indexPath.row-1)/2]
                        vc.modalPresentationStyle = .OverCurrentContext
                        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
                        let blurEffectView = UIVisualEffectView(effect: blurEffect)
                        blurEffectView.frame = UIScreen.mainScreen().bounds
                        self.view.addSubview(blurEffectView)
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        else {
            self.collectionView(self.collectionView!, didSelectItemAtIndexPath: indexPath)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}
