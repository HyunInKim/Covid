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
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var topView: UIView!
    
    private var startDate: Date?
    private var endDate: Date?
    private let today = Date()
    private var covidData: [Int] = []
    
    let showCalendarRowView: PanModalPresentable.LayoutType = CalendarmodalViewController()
//    fileprivate lazy var dateFormatter: DateFormatter = {
//           let formatter = DateFormatter()
//           formatter.dateFormat = "yyyyMMdd"
//           return formatter
//    }()
    
    var numberOfItems = 29
//    lazy var plotOneData: [Double] = self.generateRandomData(self.numberOfItems, max: 100, shouldIncludeOutliers: true)
//    lazy var plotTwoData: [Double] = self.generateRandomData(self.numberOfItems, max: 80, shouldIncludeOutliers: false)
//
//    lazy var pinkLinePlotData: [Double] =  self.generateRandomData(self.numberOfItems, max: 100, shouldIncludeOutliers: false)
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.dataSource = self
       
        topView.backgroundColor = UIColor.colorFromHex(hexString: "#222222")
//        setupGraph(graphView: graphView)
        createPinkGraph(graphView: graphView)
        print("test",DataGetSet.shared.covidDeathArray)
        covidData = DataGetSet.shared.covidDeathArray
        setNavigationBar()
    }
    
    
    func setNavigationBar(){
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
    
    func setupGraph(graphView: ScrollableGraphView) {
        
        
        graphView.backgroundFillColor = UIColor(red: 0.16, green: 0.25, blue: 0.45, alpha: 1.00)
        // Setup the first line plot.
        let blueLinePlot = LinePlot(identifier: "one")
        
        blueLinePlot.lineWidth = 5
        blueLinePlot.lineColor = UIColor.blue
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        blueLinePlot.shouldFill = false
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = UIColor.blue
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second line plot.
        let orangeLinePlot = LinePlot(identifier: "two")
        
        orangeLinePlot.lineWidth = 5
        orangeLinePlot.lineColor = UIColor.red
        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        orangeLinePlot.shouldFill = false
        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
        orangeLinePlot.fillColor = UIColor.red
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Customise the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        
        // All other graph customisation is done in Interface Builder,
        // e.g, the background colour would be set in interface builder rather than in code.
        // graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        graphView.addPlot(plot: orangeLinePlot)
    }
    
    
    func createPinkGraph(graphView: ScrollableGraphView) {
        
        // Setup the plot
        let linePlot = LinePlot(identifier: "covid")
        
        linePlot.lineColor = UIColor.clear
        linePlot.shouldFill = true
        linePlot.fillColor = UIColor.colorFromHex(hexString: "#FF0080")
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineThickness = 1
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        
        referenceLines.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
        referenceLines.dataPointLabelColor = UIColor.white
        referenceLines.dataPointLabelsSparsity = 1
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#222222")
        
        graphView.dataPointSpacing = 60
        graphView.shouldAdaptRange = true
        
        // Add everything
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
    }
    
    
    @IBAction func showCalendar(_ sender: Any) {
        presentPanModal(showCalendarRowView)
    }
    

}

extension MainViewController: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
//        case "one":
//            return plotOneData[pointIndex]
//        case "two":
//            return plotTwoData[pointIndex]
//        case "pinkLine":
//            return pinkLinePlotData[pointIndex]
        case "covid":
            return Double(covidData[pointIndex])
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "FEB \(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return covidData.count
    }
    
    
}
