//
//  StatsViewController.swift
//  Sulchedule
//
//  Created by herojeff on 03/08/2018.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    var heightTemp: CGFloat = 0.0
    var bounds = UIScreen.main.bounds
    var height: CGFloat = 0.0

    @IBOutlet weak var embedView: UIView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBAction func topSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            leftSegment()
        case 1:
            rightSegment()
        default:
            print("wtf")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        heightTemp = embedView.bounds.height
        height = bounds.size.height
        heightTemp = height - 280.0
    }
    
    func leftSegment(){
        leaderboardView.isHidden = false
        embedView.frame.size.height = heightTemp
    }
    
    func rightSegment(){
        leaderboardView.isHidden = true
        embedView.frame.size.height = height
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
