//
//  ViewController.swift
//  covid
//
//  Created by 김현인 on 2020/09/29.
//

import UIKit
import SnapKit
import PanModal
import ScrollableGraphView

protocol RowPresentable {
    var showCalendarRowView: UIViewController & PanModalPresentable { get }
}
    
class MainViewController: UIViewController, RowPresentable, SendDataDelegate {
    @IBOutlet weak var topView: UIView!
    
    private var startDate: Date?
    private var endDate: Date?
    private let today = Date()
    private var covidData: [Int] = []
    
    let showCalendarRowView: PanModalPresentable.LayoutType = CalendarmodalViewController()

    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = UIColor.colorFromHex(hexString: "#222222")
        covidData = DataGetSet.shared.covidDeathArray
        setNavigationBar()
    }
    
    private func setNavigationBar(){
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func sendDateData(startDate: Date?, endDate: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        Network.shared.getCovidStatus(pageNo: 1,
                               numberOfRows: 10,
                               startCreateDt: dateFormatter.string(from: startDate!),
                               endCreateDt: dateFormatter.string(from: endDate!)) { (covid) in
            guard let result = covid else {return}
            self.covidData.removeAll()
            DataGetSet.shared.covidDeathArray.removeAll()
            result.itemList.forEach {
                DataGetSet.shared.covidDeath = $0.deathCnt
            }
            self.covidData = DataGetSet.shared.covidDeathArray
            
            
            print("==",self.covidData)
        }
////        print("startDate:\(startDate), \(endDate)")
//        self.startDate = startDate
//        self.endDate = endDate
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        presentPanModal(showCalendarRowView)
    }
    

}


