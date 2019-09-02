//
//  AccordionController.swift
//  M46Swift
//
//  Created by David Jobe on 2019-09-02.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

open class AccordionController : UITableViewController {
    open var expandedIndexes = [IndexPath]()
    open var isToggleAnimated = true
    open var shouldScrollIfNeededAfterCellExpand = true
    
    open var onExpandComplete: () -> Void = {}
    open var onCollapseComplete: () -> Void = {}
    
    open func toggleCell(_ cell: AccordionCell, animated: Bool) {
        if cell.expanded {
            collapseCell(cell, animated: animated)
        } else {
            expandCell(cell, animated: animated)
        }
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AccordionCell {
            toggleCell(cell, animated: isToggleAnimated)
        }
    }
    
    private func expandCell(_ cell: AccordionCell, animated: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            if !animated {
                addToExpandedIndexPaths(indexPath)
                cell.setExpanded(true, animated: false)
                tableView.reloadData()
                scrollIfNeededAfterExpandingCell(at: indexPath)
                onExpandComplete()
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock { [weak self] in
                    self?.scrollIfNeededAfterExpandingCell(at: indexPath)
                    self?.onExpandComplete()
                }
                
                tableView.beginUpdates()
                addToExpandedIndexPaths(indexPath)
                cell.setExpanded(true, animated: true)
                tableView.endUpdates()
                
                CATransaction.commit()
            }
        }
    }
    
    private func collapseCell(_ cell: AccordionCell, animated: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            if !animated {
                cell.setExpanded(false, animated: false)
                removeFromExpandedIndexPaths(indexPath)
                tableView.reloadData()
                onCollapseComplete()
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock { [weak self] in
                    self?.onCollapseComplete()
                }
                
                tableView.beginUpdates()
                cell.setExpanded(false, animated: true)
                removeFromExpandedIndexPaths(indexPath)
                tableView.endUpdates()
                
                CATransaction.commit()
            }
        }
    }
    
    private func addToExpandedIndexPaths(_ indexPath: IndexPath) {
        expandedIndexes.append(indexPath)
    }
    
    private func removeFromExpandedIndexPaths(_ indexPath: IndexPath) {
        if let index = expandedIndexes.firstIndex(of: indexPath) {
            expandedIndexes.remove(at: index)
        }
    }
    
    private func scrollIfNeededAfterExpandingCell(at indexPath: IndexPath) {
        guard shouldScrollIfNeededAfterCellExpand,
            let cell = tableView.cellForRow(at: indexPath) as? AccordionCell else {
                return
        }
        let cellRect = tableView.rectForRow(at: indexPath)
        let isCompletelyVisible = tableView.bounds.contains(cellRect)
        if cell.expanded && !isCompletelyVisible {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
