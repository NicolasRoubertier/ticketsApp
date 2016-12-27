//
//  TicketStackController.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 7/19/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ticketStackCell"

private let rectoVerso : [String : String] = ["semiFinalTicketFront20.png" : "semiFinalTicketBack.png", "semiFinalTicketFront21.png" : "semiFinalTicketBack.png"]

private let tickets : [String] = ["semiFinalTicketFront20.png", "semiFinalTicketFront21.png"]

enum TicketState : Int {
    case normal = 0
    case selected = 1
    case collapsed = 2
}

enum TicketFace : Int {
    case front = 0
    case back = 1
}

extension TicketStackController : PassbookLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightOfCellAtIndexPath indexPath:IndexPath) -> CGFloat {
        let image : UIImage = UIImage(named: tickets[indexPath.row])!
        let sizeRate : CGFloat = CGFloat(image.size.width/(self.collectionView!.frame.size.width*0.96))
        return CGFloat((image.size.height)/sizeRate)
    }
    
    func widthOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat {
        return CGFloat(self.collectionView!.frame.size.width*0.96)
    }
    
    func xOffsetOfTicketsOfCollectionView(_ collectionView: UICollectionView) -> CGFloat {
        return CGFloat(self.collectionView!.frame.size.width*0.02)
    }
    
    func getScrollOffset(_ collectionView: UICollectionView) -> CGPoint {
        return self.offset
    }
    
    func getSelectedCellCollectionView(_ collectionView: UICollectionView) -> Int {
        return selectedCell
    }
}

class TicketStackController: UICollectionViewController {
    
    fileprivate var selectedCell : Int = -1

    fileprivate var offset : CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? TicketStackLayout {
            layout.delegate = self
        }
        
        /*self.collectionView!.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view!.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.view!.insertSubview(blurEffectView, atIndex: 0)*/
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectTicket)))
        
        self.automaticallyAdjustsScrollViewInsets = true
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tickets.count 
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TicketStackCell
        
        
        cell.imageContainer.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        cell.frontImageView = UIImageView(frame: CGRect(x: cell.imageContainer.frame.origin.x, y: cell.imageContainer.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height))
        cell.frontImageView.image = UIImage(named: tickets[indexPath.row])!
        cell.frontImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        cell.backImageView = UIImageView(frame: CGRect(x: cell.imageContainer.frame.origin.x, y: cell.imageContainer.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height))
        cell.backImageView.image = UIImage(named: rectoVerso[tickets[indexPath.row]]!)!
        cell.backImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        cell.imageContainer.addSubview(cell.frontImageView)
        
        cell.state = TicketState.normal.rawValue
        cell.face = TicketFace.front.rawValue
    
        return cell
    }
    
    func setSelectedCell() {
        
        selectedCell = -1
        let items : Int = self.collectionView!.numberOfItems(inSection: 0)
        for item in 0..<items {
            if let cell = self.collectionView!.cellForItem(at: IndexPath(item: item, section: 0)) as? TicketStackCell {
                if cell.state == TicketState.selected.rawValue {
                    selectedCell = item
                }
            }
        }
    }
    
    func selectTicket(_ sender: UITapGestureRecognizer) {
        
        if offset == nil {
            offset = (self.collectionView?.contentOffset)!
        }
        let tappedPoint : CGPoint = sender.location(ofTouch: 0, in: self.collectionView)
        if selectedCell == -1 {
          if(tappedPoint.x >= self.collectionView!.frame.size.width*0.02 && tappedPoint.x <= self.collectionView!.frame.size.width*0.98) {
              let numberOfGaps : Int = min(Int(floor((tappedPoint.y)/57.1)), tickets.count-1)
              let items : Int = self.collectionView!.numberOfItems(inSection: 0)
              for item in 0..<items {
                  if let cell = self.collectionView!.cellForItem(at: IndexPath(item: item, section: 0)) as? TicketStackCell {
                      if item == numberOfGaps {
                          cell.state = TicketState.selected.rawValue
                      }
                      else {
                          cell.state = TicketState.collapsed.rawValue
                      }
                  }
              }
              setSelectedCell()
              self.collectionView!.collectionViewLayout.invalidateLayout()
              let newLayout = TicketStackCollapsedLayout()
              newLayout.delegate = self
              self.collectionView!.setCollectionViewLayout(newLayout, animated: true)
          }
        }
        else {
            let items : Int = self.collectionView!.numberOfItems(inSection: 0)
            if let mainCell = self.collectionView!.cellForItem(at: IndexPath(item: selectedCell, section: 0)) as? TicketStackCell {
                let height = mainCell.imageContainer.frame.height
                if(tappedPoint.x >= self.collectionView!.frame.size.width*0.02 && tappedPoint.x <= self.collectionView!.frame.size.width*0.98 && tappedPoint.y<=height) {
                    turnTicket()
                }
                else {
                    for item in 0..<items {
                        if let cell = self.collectionView!.cellForItem(at: IndexPath(item: item, section: 0)) as? TicketStackCell {
                            cell.state = TicketState.normal.rawValue
                            if item == selectedCell {
                                if cell.face == TicketFace.back.rawValue {
                                    UIView.transition(from: cell.backImageView, to: cell.frontImageView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
                                    cell.face = TicketFace.front.rawValue
                                }
                            }
                        }
                    }
                    setSelectedCell()
                    self.collectionView!.collectionViewLayout.invalidateLayout()
                    let newLayout = TicketStackLayout()
                    newLayout.delegate = self
                    self.collectionView!.setCollectionViewLayout(newLayout, animated: true)
                }
            }
        }
    }
    
    func turnTicket() {
        if let mainCell = self.collectionView!.cellForItem(at: IndexPath(item: selectedCell, section: 0)) as? TicketStackCell {
            
                if mainCell.face == TicketFace.front.rawValue {
                    UIView.transition(from: mainCell.frontImageView, to: mainCell.backImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
                    mainCell.face = TicketFace.back.rawValue
                    
                }
                else {
                    UIView.transition(from: mainCell.backImageView, to: mainCell.frontImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
                    mainCell.face = TicketFace.front.rawValue
                }
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
