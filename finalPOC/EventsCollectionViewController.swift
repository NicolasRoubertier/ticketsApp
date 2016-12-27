//
//  EventsCollectionViewController.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 8/9/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

private let reuseIdentifier = "eventCellContainer"

private let eventsArray : [String] = ["semiFinalEvent.png", "finalEvent.png"]

extension EventsCollectionViewController : EventsLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        let image : UIImage = UIImage(named: eventsArray[indexPath.row])!
        let sizeRate : CGFloat = CGFloat(image.size.width/(self.collectionView!.frame.size.width*0.80))
        return CGFloat((image.size.height)/sizeRate)
    }
    
    func widthOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat {
        return CGFloat(self.collectionView!.frame.size.width*0.80)
    }
    
    func xOffsetOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat {
        return CGFloat(self.collectionView!.frame.size.width*0.1)
    }
    
    func yOffsetOfTicketsOfCollectionView(collectionView: UICollectionView) -> CGFloat {
        return CGFloat(self.collectionView!.frame.size.height*0.08)
    }
    
}

class EventsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? EventsCollectionViewLayout {
            layout.delegate = self
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        return eventsArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EventsCollectionViewCell
        
        cell.eventCell.image = UIImage(named: eventsArray[indexPath.row])!
        cell.eventCell.contentMode = UIViewContentMode.ScaleAspectFit
    
        // Configure the cell
    
        return cell
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }*/

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
