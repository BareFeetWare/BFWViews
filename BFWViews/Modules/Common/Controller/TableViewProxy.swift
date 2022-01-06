//
//  TableViewProxy.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 6/1/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import UIKit

public class TableViewProxy: NSObject {
    weak var delegate: UITableViewDelegate?
    var heightForSection: ((Int, Int) -> CGFloat?)?
}

extension TableViewProxy: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForSection?(section, tableView.numberOfSections)
        ?? delegate?.tableView?(tableView, heightForHeaderInSection: section)
        ?? tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        delegate?.tableView?(tableView, heightForFooterInSection: section) ?? tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        delegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
}
