//
//  TaskTableViewCell.swift
//  ToDoApp
//
//  Created by Hemant Mehra on 29/06/17.
//  Copyright © 2017 Hemant Mehra. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var status: UISwitch!
    
    var delegate: TaskCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func statusChanged(_ sender: Any) {
        print(status.isOn)
        delegate.changed(withName: taskName.text!)
        delegate.refresh()
    }
    

}

protocol  TaskCellDelegate{
    func refresh()
    func changed(withName name: String)
}
