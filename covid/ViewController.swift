//
//  ViewController.swift
//  covid
//
//  Created by 김현인 on 2020/09/29.
//

import UIKit
import PanModal

protocol RowPresentable {
   
    var rowVC: UIViewController & PanModalPresentable { get }
}
    
class ViewController: UIViewController, RowPresentable {
    
    let rowVC: PanModalPresentable.LayoutType = BasicViewController()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        presentPanModal(rowVC)
    }

}


