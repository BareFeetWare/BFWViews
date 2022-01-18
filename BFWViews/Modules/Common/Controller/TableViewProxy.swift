//
//  TableViewProxy.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 6/1/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func tableViewProxy(
        heightForHeaderInSection: ((Int) -> CGFloat?)? = nil,
        heightForFooterInSection: ((Int) -> CGFloat?)? = nil,
        willDisplayCell: ((UITableViewCell, IndexPath) -> Void)? = nil
    ) -> some View {
        uiTableView { tableView in
            if !(tableView.delegate is TableViewProxy) {
                let tableViewProxy = TableViewProxy()
                TableViewProxy.mapTable.setObject(tableViewProxy, forKey: tableView)
                tableViewProxy.delegate = tableView.delegate
                tableView.delegate = tableViewProxy
                tableViewProxy.heightForHeaderInSection = heightForHeaderInSection
                tableViewProxy.heightForFooterInSection = heightForFooterInSection
                tableViewProxy.willDisplayCell = willDisplayCell
                tableView.reloadData() // Needed?
            }
        }
    }
}

public class TableViewProxy: NSObject {
    weak var delegate: UITableViewDelegate?
    var heightForHeaderInSection: ((Int) -> CGFloat?)?
    var heightForFooterInSection: ((Int) -> CGFloat?)?
    var willDisplayCell: ((UITableViewCell, IndexPath) -> Void)?
}

private extension TableViewProxy {
    static var mapTable: NSMapTable<UITableView, TableViewProxy> = .weakToStrongObjects()
}

/// Intercepts calls to the UITableView's delegate.
extension TableViewProxy: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForHeaderInSection?(section)
        ?? delegate?.tableView?(tableView, heightForHeaderInSection: section)
        ?? tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        heightForFooterInSection?(section)
        ?? delegate?.tableView?(tableView, heightForFooterInSection: section)
        ?? tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        delegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell?(cell, indexPath)
        ?? delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        delegate?.tableView?(tableView, shouldSpringLoadRowAt: indexPath, with: context) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        delegate?.tableView?(tableView, canFocusRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        delegate?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        delegate?.tableView?(tableView, shouldBeginMultipleSelectionInteractionAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didBeginMultipleSelectionInteractionAt: indexPath)
    }
    
    public func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        delegate?.tableViewDidEndMultipleSelectionInteraction?(tableView)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        delegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        indexPath
        // This doesn't seem to pass on the call:
        //delegate?.tableView?(tableView, willSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        delegate?.tableView?(tableView, willDeselectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        delegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        delegate?.tableView?(tableView, shouldUpdateFocusIn: context) ?? true
    }
    
    @available(iOS 15.0, *)
    public func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
        delegate?.tableView?(tableView, selectionFollowsFocusForRowAt: indexPath) ?? true
    }
    
    // TODO: Add remaining delegate calls
    
}
