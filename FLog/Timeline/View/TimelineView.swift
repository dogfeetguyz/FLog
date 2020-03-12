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
    
    var presenter: TimelinePresenterProtocol?
    var timelineArray = Array<TimelineModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
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
    func showTimelines(with timelineArray: [TimelineModel]) {
        self.timelineArray = timelineArray
        
        tableView.reloadData()
    }
}
