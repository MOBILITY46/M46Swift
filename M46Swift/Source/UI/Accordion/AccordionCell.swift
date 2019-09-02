//
//  AccordionCell.swift
//  M46Swift
//
//  Created by David Jobe on 2019-09-02.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

open class AccordionCell : UITableViewCell {
    open private(set) var expanded = false
    
    open func setExpanded(_ expanded: Bool, animated: Bool) {
        self.expanded = expanded
    }
}
