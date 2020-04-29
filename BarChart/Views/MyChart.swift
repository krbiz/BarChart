//
//  MyChart.swift
//  BarChart
//
//  Created by Dima Krupskyi on 28.04.2020.
//  Copyright © 2020 Dima Krupskyi. All rights reserved.
//

import UIKit
import SnapKit

class MyChart: UIView {
    
    let distanceBetweenColumns: CGFloat = 10
    
    var charts: [ChartData]?
    var currentChartIndex = 0
    var columnsPath: [CGRect] = []
    
    var timerAnimation: Timer?
    
    var columnWidth: CGFloat {
        guard let charts = charts else { return 0 }
        let chart = charts[currentChartIndex]
        let count = CGFloat(chart.items.count)
        let width = (self.bounds.width - distanceBetweenColumns * (count - 1)) / count
        return width
    }
    
    // MARK: - Initializations
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: .common)
        
    }
    
    convenience init(charts: [ChartData]) {
        self.init(frame: .zero)
        self.charts = charts
    }
    
    private func setupColumnsPath() {
        guard let charts = charts else { return }
        let items = charts[currentChartIndex].items
        
        columnsPath.removeAll()
        for (index, item) in items.enumerated() {
            let rect = CGRect(x: CGFloat(index) * (columnWidth + distanceBetweenColumns),
                              y: self.bounds.height,
                              width: columnWidth,
                              height: -convertValueToHeight(value: CGFloat(item.value)))
            columnsPath.append(rect)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let charts = charts else { return }
        let currentItems = charts[currentChartIndex].items
        let nextItems = currentChartIndex < charts.count - 1 ? charts[currentChartIndex + 1].items : charts[0].items
        
        let animationDuration = 0.5
        
        let deltasForCurrentChart =
            currentItems.map({ convertValueToHeight(value: CGFloat($0.value / (animationDuration / 2 * 60))) })
        
        let deltasForNextChart =
            nextItems.map({ convertValueToHeight(value: CGFloat($0.value / (animationDuration / 2 * 60))) })
        
        var repeatsCount = Int(animationDuration * 60)
        
        timerAnimation = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { timer in
            for (index, path) in self.columnsPath.enumerated() {
                let delta = repeatsCount > Int(animationDuration * 60) / 2 ? deltasForCurrentChart[index] : -deltasForNextChart[index]
                self.columnsPath[index] =
                    CGRect(origin: path.origin, size: CGSize(width: path.width, height: -path.height + delta))
            }
            repeatsCount -= 1
            self.setNeedsDisplay()
            
            if repeatsCount == Int(animationDuration * 60) / 2 {
                self.currentChartIndex = self.currentChartIndex < charts.count - 1 ? self.currentChartIndex + 1 : 0
            }
            
            if repeatsCount == 0 {
                timer.invalidate()
                self.setupColumnsPath()
            }
        })
    }
    
    
    @objc func update() {
        //print("Updating!")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupColumnsPath()
    }
    
    func convertValueToHeight(value: CGFloat) -> CGFloat {
        return bounds.height / 100 * value
    }
    
    override func draw(_ rect: CGRect) {
        guard let charts = charts, !columnsPath.isEmpty else { return }
        let items = charts[currentChartIndex].items
        
        for (index, item) in items.enumerated() {
            let rect = columnsPath[index]
            let rectanglePath = UIBezierPath(rect: rect)
            item.color.setFill()
            rectanglePath.fill()
        }
    }
    
}
