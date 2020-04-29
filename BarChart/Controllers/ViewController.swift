//
//  ViewController.swift
//  BarChart
//
//  Created by Dima Krupskyi on 27.04.2020.
//  Copyright © 2020 Dima Krupskyi. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var myChart = MyChart()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        
        let button = UIButton()
        button.setTitle("Click", for: .normal)
        button.addTarget(self, action: #selector(actionbuttonClick), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func actionbuttonClick() {
        myChart.addChart(data: ChartData.randomData())
    }
    
    func setupChart() {
        let chartA = ChartData.randomData()
        let chartB = ChartData.randomData()
        
        myChart.addChart(data: chartA)
        myChart.addChart(data: chartB)
        
        view.addSubview(myChart)
        myChart.backgroundColor = #colorLiteral(red: 0.06622779188, green: 0.06622779188, blue: 0.06622779188, alpha: 1)
        
        myChart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
        }
    }
    
}

