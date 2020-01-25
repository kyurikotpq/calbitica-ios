//
//  AddCalbitVC.swift
//  Calbitica
//
//  Created by Student on 25/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class SaveCalbitVC: UIViewController {
    var calbitTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavbar()
        
    }
    
    func setupNavbar() {
        self.navigationItem.title = (calbitTitle == "") ? "Add new event" : calbitTitle
        
        // Since we modified our navbar earlier, we need to add our own
        // save button
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: #selector(saveBtnPressed))
        saveBtn.tintColor = .white
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    @objc func saveBtnPressed() {
        
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
