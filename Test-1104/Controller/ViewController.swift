//
//  ViewController.swift
//  Test-1104
//
//  Created by Amit Prajapati on 11/04/22.
//

import UIKit
import DropDown

class ViewController: UIViewController {
    
    @IBOutlet weak var btnSelectDepartment: UIButton!
    let dropDown = DropDown()
    var arrDepartment : [String] = ["iOS", "Android", "Web"]
    @IBOutlet weak var tblDisEmployee: UITableView!
    //var arrNoOfDepart = [String]()
    var arrNoOfEmployee = [EmployeeM]()
    var addEmpInSec : Int = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblDisEmployee.delegate = self
        tblDisEmployee.dataSource = self
        
        let nib = UINib(nibName: "EmployeeTVCell", bundle: nil)
        tblDisEmployee.register(nib, forCellReuseIdentifier: "Cell")
        
        let nib2 = UINib(nibName: "CustomTableHeaderView", bundle: nil)
        tblDisEmployee.register(nib2, forHeaderFooterViewReuseIdentifier: "customTblHeaderView")
        
        loadEmpData()
    }

    func loadEmpData() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "employee") {
            let array = try! PropertyListDecoder().decode([EmployeeM].self, from: data)
            arrNoOfEmployee = array
            tblDisEmployee.reloadData()
        }
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        //let saveEmpData = NSKeyedArchiver.archivedData(withRootObject: arrNoOfEmployee)
        do {
            if let data = try? PropertyListEncoder().encode(arrNoOfEmployee) {
                UserDefaults.standard.set(data, forKey: "employee")
            }
        } catch {
            print("Error")
        }
    }
    
    @IBAction func btnSelectDepartment(_ sender: UIButton) {
        
        dropDown.dataSource = arrDepartment
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            //sender.setTitle(item, for: .normal)
            if (self?.arrNoOfEmployee.count)! < 3 && (self?.arrNoOfEmployee.count)! >= 1 {
                for i in 1...(self?.arrNoOfEmployee.count)! {
                    if self?.arrNoOfEmployee[i-1].department != self!.arrDepartment[index], (self?.arrNoOfEmployee.count)! != 3 {
                        self?.arrNoOfEmployee.insert(EmployeeM(department: self!.arrDepartment[index], employee: [Employee(email: "")]), at: 0)
                        self?.tblDisEmployee.reloadData()
                    }
                }
            } else if (self?.arrNoOfEmployee.count)! == 0 {
                //self?.arrNoOfDepart.append(self!.arrDepartment[index])
                //self?.arrNoOfEmployee.append(EmployeeM(department: self!.arrDepartment[index], employee: [Employee(email: "")]))
                self?.arrNoOfEmployee.insert(EmployeeM(department: self!.arrDepartment[index], employee: [Employee(email: "")]), at: 0)
                self?.tblDisEmployee.reloadData()
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func checkDuplicateEmp(_ email: String, tblSectoin : Int, tblRow : Int) -> Bool {
        for i in 0...arrNoOfEmployee.count - 1 {
            for (index,item) in arrNoOfEmployee[i].employee.enumerated() {
                if item.email == email && (tblSectoin != i || tblRow != index){
                    return false
                }
            }
        }
        return true
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource, EmployeeDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customTblHeaderView") as? CustomTableHeaderView {
            headerView.lblHeader.text = arrNoOfEmployee[section].department
            headerView.btnAdd.tag = section
            headerView.btnAdd.addTarget(self, action:#selector(addEmployeeInSection(sender: )) , for: .touchUpInside)
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrNoOfEmployee.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNoOfEmployee[section].employee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EmployeeTVCell
        cell.employeeDelegate = self
        cell.btnRemove.superview?.tag = indexPath.section
        cell.btnRemove.tag = indexPath.row
        cell.txtEmail.delegate = self
        cell.txtEmail.superview?.tag = indexPath.section
        cell.txtEmail.tag = indexPath.row
        cell.txtEmail.text = arrNoOfEmployee[indexPath.section].employee[indexPath.row].email
        cell.switchStatus.superview?.tag = indexPath.section
        cell.switchStatus.tag = indexPath.row
        cell.switchStatus.setOn(arrNoOfEmployee[indexPath.section].employee[indexPath.row].isStatus, animated: false)
        return cell
    }
    
    @objc func addEmployeeInSection(sender : UIButton) {
        arrNoOfEmployee[sender.tag].employee.append(Employee(email: ""))
        tblDisEmployee.reloadData()
    }
    
    func removeEmployee(sender: UIButton) {
        arrNoOfEmployee[sender.superview!.tag].employee.remove(at: sender.tag)
        
        if arrNoOfEmployee[sender.superview!.tag].employee.count == 0 {
            arrNoOfEmployee.remove(at: sender.superview!.tag)
            //arrNoOfDepart.remove(at: sender.superview!.tag)
        }
        
        tblDisEmployee.reloadData()
    }
    
    func setEmployeeStatus(sender: UISwitch, selected: Bool) {
        arrNoOfEmployee[sender.superview!.tag].employee[sender.tag].isStatus = selected
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
                   let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                               with: string)
            arrNoOfEmployee[textField.superview!.tag].employee[textField.tag].email = updatedText
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: textField.tag, section: textField.superview!.tag)
        let cell = tblDisEmployee.cellForRow(at: indexPath) as! EmployeeTVCell
        
        if !isValidEmail(textField.text!) {
            cell.lblerror.isHidden = false
        } else {
            cell.lblerror.isHidden = true
            if !checkDuplicateEmp(textField.text!, tblSectoin: textField.superview!.tag, tblRow: textField.tag) {
                
                let alert = UIAlertController(title: "Alert", message: "Available employee with this email.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    cell.txtEmail.text = ""
                    self.arrNoOfEmployee[textField.superview!.tag].employee[textField.tag].email = ""
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
