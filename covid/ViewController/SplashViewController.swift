//
//  SplashViewController.swift
//  covid
//
//  Created by 김현인 on 2020/10/17.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
    }
    override func viewDidAppear(_ animated: Bool) {
        checkDeviceNetworkStatus()
    }
    
    private func checkDeviceNetworkStatus() {
        if Global.shared.networkStatus {
            getDefaultCovidData()
            let time: DispatchTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(700)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewNavigation")
                mainViewController.modalPresentationStyle = .fullScreen
                self.present(mainViewController, animated: true, completion: nil)
            })

        } else {
            let alert: UIAlertController = UIAlertController(title: "네트워크 상태 확인", message: "네트워크가 불안정 합니다.", preferredStyle: .alert)
            let action: UIAlertAction = UIAlertAction(title: "다시 시도", style: .default, handler: { (ACTION) in
                self.checkDeviceNetworkStatus()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }

    private func getDefaultCovidData() {
        let startDate = Global.shared.todayArrays.last!
        let endDate = Global.shared.todayArrays.first!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        Network.shared.getCovidStatus(pageNo: 1,
                               numberOfRows: 10,
                               startCreateDt: dateFormatter.string(from: startDate),
                               endCreateDt: dateFormatter.string(from: endDate)) { (covid) in
            guard let result = covid else {return}
            result.itemList.forEach {
                DataGetSet.shared.covidDeath = $0.deathCnt
            }
        }
    }
}
