//
//  ViewController.swift
//  HalfPieChart
//
//  Created by Nitin Aggarwal on 20/04/21.
//

import UIKit
import Charts
import SnapKit

class ViewController: UIViewController {

    // MARK: - Properties
    private let chartView = PieChartView()
    private var chartValues: [ChartData]?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSetup()
        initialSetup()
        setupChart()
        setDataCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateChart()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        navigationItem.title = "Half Pie Chart"
        view.backgroundColor = .white
        view.addSubview(chartView)
        
        // adding constraint on chart view using SnapKit. (you can use your's way)
        chartView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.9)
            make.height.equalTo(200)
            make.center.equalToSuperview()
        }
    }
    
    private func dataSetup() {
        chartValues = [
            ChartData(colorString: "#ff0800", percentage: 30.0, text: "Apple"),
            ChartData(colorString: "#ffc324", percentage: 10.0, text: "Mango"),
            ChartData(colorString: "#563c0d", percentage: 25.0, text: "Pineapple"),
            ChartData(colorString: "#568203", percentage: 10.0, text: "Avocado"),
            ChartData(colorString: "#98a57f", percentage: 20.0, text: "Guava")
        ]
    }
    
    
    // MARK: - Chart Setup
    private func setupChart() {
        chartView.drawEntryLabelsEnabled = false
        chartView.usePercentValuesEnabled = false
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.50 // chart width percentage
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = true
        chartView.holeColor = .clear
        chartView.transparentCircleColor = .clear
        chartView.drawHoleEnabled = true
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.maxAngle = 180 // Set 180 angle to make half chart
        chartView.rotationAngle = 180 // rotate to make the half on the upper side
        chartView.centerTextOffset = CGPoint(x: 0, y: -30)
        chartView.legend.enabled = true
        chartView.drawCenterTextEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 15
        
        let centerText = NSMutableAttributedString(string: "Total Values", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.systemGray, .paragraphStyle: paragraphStyle])
        centerText.append(NSAttributedString(string: "\n\(self.chartValues?.count ?? 0)", attributes: [.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.black, .paragraphStyle: paragraphStyle]))
        chartView.centerAttributedText = centerText
    }

    private func setDataCount() {
        
        var colors = [NSUIColor]()
        var dataEntries: [PieChartDataEntry] = []
        
        if let dataArray = self.chartValues, dataArray.isEmpty == false {
            dataEntries = dataArray.map { (chartValue) -> PieChartDataEntry in
                colors.append(ChartColorTemplates.colorFromString(chartValue.colorString))
                let entry = PieChartDataEntry(value: chartValue.percentage, label: chartValue.text)
                return entry
            }
        } else {
            colors.append(ChartColorTemplates.colorFromString("#e6e9ed"))
            dataEntries = [PieChartDataEntry(value: 100.0, label: "")]
        }
        
        let set = PieChartDataSet(entries: dataEntries, label: nil)
        set.sliceSpace = 0
        set.selectionShift = 0
        set.colors = colors
        
        let data = PieChartData(dataSet: set)
        data.setValueTextColor(.clear)
        chartView.data = data
        chartView.setNeedsDisplay()
    }
    
    private func animateChart() {
        self.chartView.animate(xAxisDuration: 1.2, easingOption: .easeOutBack)
    }
}

