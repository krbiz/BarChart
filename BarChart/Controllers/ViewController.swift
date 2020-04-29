//
//  ViewController.swift
//  BarChart
//
//  Created by Dima Krupskyi on 27.04.2020.
//  Copyright © 2020 Dima Krupskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var myChart: MyChart!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
    }
    
    func setupChart() {
        let chartA = ChartData.randomData()
        let chartB = ChartData.randomData1()
        
        myChart = MyChart(charts: [chartA, chartB])
        view.addSubview(myChart)
        myChart.backgroundColor = #colorLiteral(red: 0.06622779188, green: 0.06622779188, blue: 0.06622779188, alpha: 1)
        
        myChart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
        }
    }
    
}

