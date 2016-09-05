//
//  DeleteDeckViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 5/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

class DeleteDeckViewController: UIViewController {

    var deleteDeck : ((Bool) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yesButton(sender: AnyObject) {
        deleteDeck!(true)
    }

    @IBAction func noButton(sender: AnyObject) {
        deleteDeck!(false)  
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
