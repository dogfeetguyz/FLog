//
//  RoutineDetailView.swift
//  FLog
//
//  Created by Yejun Park on 17/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import DatePickerDialog

class RoutineDetailView: KUIViewController {
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var personalRecordStackView: UIStackView!
    @IBOutlet weak var moreButton: UIButton!
    
    var presenter: RoutineDetailPresenterProtocol?
    var routineDetailData: RoutineDetailModel?
    var maxInfoData: Dictionary<String, Dictionary<String, String>>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = routineDetailData!.routine.title
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.underlineSelected = true
        segmentedControl.fixedSegmentWidth = false
        
        presenter?.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func newButtonAction() {
        self.showCreateDialog(isFirst: false)
    }
    
    @IBAction func deleteButtonAction() {
        
        Common.View.showAlertWithTwoButtons(viewController: self, title: "Delete the fitness log?", message: "", cancelButtonTitle: "Cancel", OKButtonTitle: "Delete", OKHandler: { (_) in
            let deleteIndex = self.segmentedControl.numberOfSegments - 1 - self.segmentedControl.selectedSegmentIndex
            self.presenter?.deleteLogAction(deleteIndex: deleteIndex)
        })
    }
    
    @IBAction func moreButtonAction() {
        if (moreButton.attributedTitle(for: .normal)?.string == "more") {
            moreButton.setAttributedTitle(NSAttributedString(string: "less", attributes: [NSAttributedString.Key.foregroundColor:UIColor.link]), for: .normal)
            moreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        } else {
            moreButton.setTitle("more", for: .normal)
            moreButton.setAttributedTitle(NSAttributedString(string: "more", attributes: [NSAttributedString.Key.foregroundColor:UIColor.link]), for: .normal)
            moreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        
        presenter?.loadMaxInfo()
    }
       
    @IBAction func segmentSelected(sender:ScrollableSegmentedControl) {
        tableView.reloadData()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        super.keyboardWillHide(sender: sender)
        presenter?.finishedInputData(timeStamp: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension RoutineDetailView: RoutineDetailViewProtocol {
    
    func showRoutineDetail(routineDetail: RoutineDetailModel) {
        routineDetailData = routineDetail
        
        if segmentedControl.numberOfSegments > 0 {
            for _ in Range(0 ... segmentedControl.numberOfSegments-1) {
                segmentedControl.removeSegment(at: 0)
            }
        }
        
        for dailyExercise in self.routineDetailData!.dailyExercises {
            segmentedControl.insertSegment(withTitle: dailyExercise.timeStamp, at: 0)
        }
    }
    
    func showCreateDialog(isFirst: Bool) {
        if isFirst {
            tableView.isHidden = true
        }
        DatePickerDialog().show("Choose a date", datePickerMode: .date) { (date) in
            
            if isFirst {    // if it is the first log, it should be created whether user choose a date or not
                self.presenter?.newLogAction(date: date == nil ? Date() : date!)
                self.tableView.isHidden = false
            } else {
                if date == nil {
                    return
                }
                
                self.presenter?.newLogAction(date: date!)
            }
        }
    }
    
    func updateLogView(segmentIndex: Int) {
        presenter?.loadLogs()
        self.segmentedControl.selectedSegmentIndex = segmentIndex
        DispatchQueue.main.async {  // to scroll the segmentControll, it needs to be called again as an async call
            self.segmentedControl.selectedSegmentIndex = segmentIndex
        }
        
    }
    
    func updateMaxInfoView(maxInfo: Dictionary<String, Dictionary<String, String>>) {
        self.maxInfoData = maxInfo
        
        var firstItem = true
        for subview in personalRecordStackView.arrangedSubviews {
            if firstItem {
                firstItem = false
                continue
            }
            subview.removeFromSuperview()
        }
        
        if (moreButton.attributedTitle(for: .normal)?.string == "less") {

            for exercise in routineDetailData!.routine.exerciseTitles {
                let text1 = exercise

                let unit = maxInfo[exercise]![Common.Define.mainRoutineUnit]!
                let bestMaxVolume = maxInfo[exercise]![Common.Define.routineBestMaxVolume]!
                let bestMaxVolumeDate = maxInfo[exercise]![Common.Define.routineBestMaxVolumeDate]!
                let bestMaxWeight = maxInfo[exercise]![Common.Define.routineBestMaxWeight]!
                let bestMaxWeightDate = maxInfo[exercise]![Common.Define.routineBestMaxWeightDate]!
                let text2 = String(format: "Max Volume: %@%@ (%@)\nMax Weight: %@%@ (%@)", bestMaxVolume, unit, bestMaxVolumeDate, bestMaxWeight, unit, bestMaxWeightDate)

                let text = text1 + "\n" + text2 as NSString
                let nameLabel = UILabel()
                nameLabel.numberOfLines = 3
                let attributedString = NSMutableAttributedString(string: text as String)
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: text1))
                attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: (text as NSString).range(of: text2))
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: (text as NSString).range(of: text1))
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: (text as NSString).range(of: text2))


                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, text.length))

                nameLabel.attributedText = attributedString
                personalRecordStackView.addArrangedSubview(nameLabel)
            }
        }
    }
    
    func updateTableView(routineDetail: RoutineDetailModel) {
        routineDetailData = routineDetail
        tableView.reloadData()
    }
    
    func showError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        Common.View.showAlertWithOneButton(viewController: self, title: title, message: message, buttonTitle: buttonTitle, handler: handler)
    }
}
