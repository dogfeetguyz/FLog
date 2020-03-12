//
//  RoutineView.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineView: UIViewController {
    
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: RoutinePresenterProtocol?
    var mainRoutineArray = Array<MainRoutineModel>()
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setLogo()
    }
    
    func setLogo() {
        let image: UIImage = UIImage(named: "fitlog.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        logoView.addSubview(imageView)
        
        self.navigationItem.titleView = logoView
    }
    
    
    // MARK: ButtonAction
    @IBAction func newButtonAction() {
        presenter?.clickNewButton()
    }
    
    @IBAction func editButtonAction() {
        
        if editButton.titleLabel?.text == "Edit" {
            editButton.setTitle("Done", for: .normal)
            tableView.setEditing(true, animated: true)
            newButton.isHidden = true
        } else {
            editButton.setTitle("Edit", for: .normal)
            tableView.setEditing(false, animated: true)
            newButton.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func editCellButtonAction(button: UIButton) {
        let index = button.tag
        let routine = mainRoutineArray[index]

        let alert = UIAlertController(title: "Rename", message: "Enter a new name", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = routine.title
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.presenter?.modifyCellTitle(index: index, newTitle: (textField?.text)!)
        }))

        self.present(alert, animated: true, completion: nil)  // 업데이트
    }
}

extension RoutineView: RoutineViewProtocol {
    func showRoutines(with mainRoutineArray: [MainRoutineModel]) {
        self.mainRoutineArray = mainRoutineArray
        
        tableView.reloadData()
    }
}
