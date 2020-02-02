//
//  AgendaController.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class AgendaVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addCalbitSegue") {
            // Adding new event
            let navController = segue.destination as! UINavigationController
            
            // We only have one VC for this navigation controller, so this works I guess...
            let destinationController = navController.topViewController as! SaveCalbitVC
            destinationController.isNewCalbit = true
//            destinationController.pressedDates = self.pressedDates
        } else if(segue.identifier == "detailCalbitSegue") {
            // viewing details of event
            /*
            self.pressedDates = DateUtil.calculate30Mins(date: Date(), round: true)
            let calbit = self.selectedEvent
            
            let destinationController = segue.destination as! CalbitDetailVC
            destinationController.calbit = calbit
            destinationController.delegate = self
            
            // Setup navbar (custom back button) & tabbar (hide)
            let startDateComponents = DateUtil.components(calbit.startDate)
            self.navigationItem.backBarButtonItem = UIBarButtonItem()
            self.navigationItem.backBarButtonItem?.title =
            "\(startDateComponents.day!) \(calbit.startDate.formatMMM())"
            
            destinationController.hidesBottomBarWhenPushed = true
            */
        }
    }


}
