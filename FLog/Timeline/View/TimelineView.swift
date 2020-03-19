//
//  TimelineView.swift
//  FLog
//
//  Created by Yejun Park on 14/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class TimelineView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: ViperPresenter?
    var isInitial: Bool = false
    var loadedData: ViperEntity?
    
    var canCallNextTimeline = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let _loadedData = self.loadedData as? TimelineEntityProtocol {
                if _loadedData.timelineArray.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
        }
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
}

extension TimelineView: TimelineViewProtocol {
    
    func updateVIew(with entity: ViperEntity) {
        canCallNextTimeline = true
        
        if isInitial {
            loadedData = entity
        } else {
            if let _loadedData = loadedData as? TimelineEntityProtocol {
                _loadedData.timelineArray.append(contentsOf: (entity as? TimelineEntity)!.timelineArray)
            }
        }
        tableView.reloadData()
    }
    
    func showError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        canCallNextTimeline = false
        
        if isInitial {
            if let _loadedData = loadedData as? TimelineEntityProtocol {
                _loadedData.timelineArray = []
            }
            tableView.reloadData()
        }
    }
}
