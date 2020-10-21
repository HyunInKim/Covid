//
//  CalendarmodalViewController.swift
//  PanModal
//
//  Created by 김현인 on 2020/09/29.
//

import UIKit
import PanModal
import FSCalendar
import SnapKit
import RxSwift
import RxCocoa

protocol SendDataDelegate {
    func sendDateData(startDate: Date?, endDate: Date?)
}
class CalendarmodalViewController: UIViewController {
    
    private let calendarView = FSCalendar()
    private let sendButton = UIButton()
    private let today = Date()
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    private let disposbag = DisposeBag()
    
    var delegate: SendDataDelegate?
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.allowsMultipleSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.today = nil
        self.delegate = MainViewController()
        setDefaultDates()  // 현재 날짜에서 일주일 전
        
        configureView()
        configureBind()
        
        
    }
    
    private func configureView() {
        
        sendButton.backgroundColor = UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.00)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont(name: "", size: 13)
        
                
        view.addSubview(calendarView)
        view.addSubview(sendButton)
        
        calendarView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        sendButton.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(
                UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            )
            $0.bottom.equalToSuperview().inset(200)
        }
    }
    
    private func configureBind() {
        sendButton.rx
            .tap.bind { [self] in
                if lastDate == nil {
                    lastDate = firstDate
                }
                
                delegate?.sendDateData(startDate: firstDate, endDate: lastDate)
//                dateFormatter.dateFormat = "yyyyMMdd"
//                Network.getCovidStatus(pageNo: 1,
//                                       numberOfRows: 10,
//                                       startCreateDt: dateFormatter.string(from: firstDate!),
//                                       endCreateDt: dateFormatter.string(from: lastDate!)) { (covid) in
//                    guard let result = covid else {return}
//                    print(result.itemList)
//                    
//                }
                dismiss(animated: true, completion: nil)
        }.disposed(by: disposbag)
    }
    
    private func setDefaultDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for i in 0..<Global.shared.todayArrays.count {
            calendarView.select(Global.shared.todayArrays[i])
        }
        sendButton.setTitle("\(dateFormatter.string(from: Global.shared.todayArrays.last!)) ~ \(dateFormatter.string(from: Global.shared.todayArrays.first!))",
                            for: .normal)
    }
        
    private func datesRange(from: Date, to: Date) -> [Date] {
        
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    private func initDate(calendar: FSCalendar, date: Date) {
        for selectedDate in calendar.selectedDates {
            calendar.deselect(selectedDate)
        }
        firstDate = date
        lastDate = nil
        datesRange = []
        calendar.select(date)
        sendButton.setTitle(dateFormatter.string(from: date), for: .normal)
    }
}

extension CalendarmodalViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

//    var shortFormHeight: PanModalHeight { // 최소 높이
//        return .contentHeight(200)
//    }
    
    var longFormHeight: PanModalHeight { // 최대 높이
        return .maxHeightWithTopInset(180)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
    
    var isUserInteractionEnabled: Bool {
        return true
    }
}


extension CalendarmodalViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? { // 선택된 칼라
        return UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.00)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if firstDate == nil {   // 첫날 선택
            firstDate = date
            datesRange = [firstDate!]
            //  초기에 선택되었던 날 삭제
            for selectedDate in calendar.selectedDates {
                calendar.deselect(selectedDate)
            }
            calendar.select(date)
            sendButton.setTitle(dateFormatter.string(from: date), for: .normal)
            return
            
        } else if firstDate != nil && lastDate == nil {     // 두쨋날 선택
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                sendButton.setTitle(dateFormatter.string(from: date), for: .normal)
                return
            }
            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last
            for i in range {
                calendar.select(i)
            }
            datesRange = range
            sendButton.setTitle("\(dateFormatter.string(from: (datesRange?.first)!)) ~ \(dateFormatter.string(from: (datesRange?.last)!))", for: .normal)
            return
            
        } else if firstDate != nil && lastDate != nil {     // 새로 선택할 경우
            initDate(calendar: calendar, date: date)
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 선택된 날짜를 선택할 경우 초기화
        initDate(calendar: calendar, date: date)
        
    }
}
