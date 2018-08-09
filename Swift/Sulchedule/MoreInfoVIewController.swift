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
        
        self.navigationItem.title = "deep"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        background.backgroundColor = colorDeepBackground
        
        expenseField.textColor = colorPoint
        locationField.textColor = colorPoint
        friendsField.textColor = colorPoint
        
        if(isBrightTheme){
            expenseField.tintColor = .black
            locationField.tintColor = .black
            friendsField.tintColor = .black
            expenseField.keyboardAppearance = .light
            locationField.keyboardAppearance = .light
            friendsField.keyboardAppearance = .light
        }
        else{
            expenseField.tintColor = .white
            locationField.tintColor = .white
            friendsField.tintColor = .white
            expenseField.keyboardAppearance = .dark
            locationField.keyboardAppearance = .dark
            friendsField.keyboardAppearance = .dark
        }
        
        expenseField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        locationField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        friendsField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        expenseField.text = ""
        locationField.text = ""
        friendsField.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        expenseField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        locationField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        friendsField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
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
