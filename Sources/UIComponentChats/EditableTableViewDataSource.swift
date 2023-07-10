//
//  EditableTableViewDataSource.swift
//
//
//  Created by X Tommy on 2023/1/18.
//

import UIComponentCore
import UIKit
import Web3MQ

public class EditableTableViewDataSource: UITableViewDiffableDataSource<
    SingleListSection, ChannelItem
>
{

    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath)
        -> Bool
    {
        return true
    }

}
