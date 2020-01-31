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
    var isNewCalbit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavbar()
    }
    
    
    // status bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()

        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.black
        statusBarView.backgroundColor = statusBarColor

        view.addSubview(statusBarView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavbar() {
        self.navigationItem.title = calbitTitle
        
        // Since we modified our navbar earlier, we need to add our own
        // save button
//        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: #selector(saveBtnPressed))
//        saveBtn.tintColor = .white
//        self.navigationItem.rightBarButtonItem = saveBtn
    }
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // dismiss yourself
    }
//
//    @objc func saveBtnPressed() {
//
//    }

    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
//        Calbitica.createCalbit()
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
