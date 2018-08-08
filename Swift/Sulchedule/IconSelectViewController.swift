//
//  IconSelectViewController.swift
//  Sulchedule
//
//  Created by herojeff on 07/08/2018.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit

class IconSelectViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.backgroundColor = colorLightBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(isBrightTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
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
