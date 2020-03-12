//
//  RoutineView+UITableViewDataSource.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

extension RoutineView: UITableViewDelegate, UITableViewDataSource {
        

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routine = mainRoutineArray[indexPath.row]
        presenter?.clickRoutineCell(forRoutine: routine)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainRoutineArray.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            Common.View.showAlertWithTwoButtons(viewController: self, title: "Delete the routine?", message: "", cancelButtonTitle: "Cancel", OKButtonTitle: "Delete", OKHandler: { (_) in
                self.presenter?.deleteCell(index: indexPath.row)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter?.moveCell(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineViewCell", for: indexPath) as! RoutineViewCell
        let routine = mainRoutineArray[indexPath.row]
        
        let exercises = routine.exerciseTitles
        let exercise: String = exercises.joined(separator: "\n")
        cell.contentLabel.numberOfLines = exercises.count
        
        cell.titleLabel?.text = routine.title

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attrString = NSMutableAttributedString(string: exercise)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        cell.editButton.tag = indexPath.row
        cell.contentLabel?.attributedText = attrString
        
        cell.editButton.isHidden = !tableView.isEditing
        
        return cell
    }
}
