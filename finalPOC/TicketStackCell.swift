//
//  TicketStackCell.swift
//  finalPOC
//
//  Created by Nicolas Roubertier on 7/19/16.
//  Copyright © 2016 NR. All rights reserved.
//

import UIKit

class TicketStackCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    
    var frontImageView : UIImageView!
    
    var backImageView : UIImageView!
    
    var state : Int!
    
    var face : Int!
}
