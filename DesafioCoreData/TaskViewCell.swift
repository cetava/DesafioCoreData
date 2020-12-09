//
//  TaskViewCell.swift
//  DesafioCoreData
//
//  Created by Cesar A. Tavares on 09/12/20.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var labelTask: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(task: Task) {
        labelTask.text = task.name
        if task.iscompleted {
            backgroundColor = .lightGray
        } else {
            backgroundColor = .white
        }
    }

}
