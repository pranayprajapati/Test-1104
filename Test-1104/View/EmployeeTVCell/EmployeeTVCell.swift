//
//  EmployeeTVCell.swift
//  Test-1104
//
//  Created by Amit Prajapati on 11/04/22.
//

import UIKit

protocol EmployeeDelegate {
    func removeEmployee(sender: UIButton)
    func setEmployeeStatus(sender: UISwitch, selected: Bool)
}

class EmployeeTVCell: UITableViewCell {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblerror: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var switchStatus: UISwitch!
    var employeeDelegate : EmployeeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func switchStatus(_ sender: UISwitch) {
        employeeDelegate?.setEmployeeStatus(sender: sender, selected: sender.isOn)
    }
    
    @IBAction func btnRemove(_ sender: UIButton) {
        employeeDelegate?.removeEmployee(sender: sender)
    }
}
