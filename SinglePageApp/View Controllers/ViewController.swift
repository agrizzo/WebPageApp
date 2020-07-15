//
//  ViewController.swift
//  SinglePageApp
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func staticButtonPressed(_ sender: Any) {
        self.navigationController?.pushViewController(StaticContentViewController(), animated: true)
    }
    
    @IBAction func urlButtonPressed(_ sender: Any) {
        self.navigationController?.pushViewController(URLContentViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

