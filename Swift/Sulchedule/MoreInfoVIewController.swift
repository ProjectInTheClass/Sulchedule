//
//  MoreInfoVIewController.swift
//  Sulchedule
//
//  Created by herojeff on 09/08/2018.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit

class MoreInfoVIewController: UIViewController {

    @IBOutlet weak var expenseField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var friendsField: UITextField!
    @IBOutlet var background: UIView!
    
    @IBAction func expenseField(_ sender: Any) {
        //pass data
    }
    @IBAction func locationField(_ sender: Any) {
        //pass data
    }
    @IBAction func friendsField(_ sender: Any) {
        //pass data
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        background.backgroundColor = colorDeepBackground
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
