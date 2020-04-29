//
//  MyChart.swift
//  BarChart
//
//  Created by Dima Krupskyi on 28.04.2020.
//  Copyright © 2020 Dima Krupskyi. All rights reserved.
//

import UIKit

class MyChart: UIView {
    
    var distanceBetweenColumns = 10.0
    var animationDuration = 0.5
    var animationFPS = 60.0
    
    var charts: [ChartData] = []
    
    private var currentChartIndex = 0
    private var columnsPath: [CGRect] = []
    private var timerDelay: Timer?
    
    var columnWidth: CGFloat {
        if charts.isEmpty { return 0 }
        let chart = charts[currentChartIndex]
        let count = CGFloat(chart.items.count)
        let width = (bounds.width - CGFloat(distanceBetweenColumns) * (count - 1)) / count
        return width
    }
    
    // MARK: - Override Methods
    
    override func didMoveToSuperview() {
        startAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupColumnsPath()
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeChartWithAnimation()
    }
    
    override func draw(_ rect: CGRect) {
        if charts.isEmpty || columnsPath.isEmpty { return }
        let items = charts[currentChartIndex].items
        
        for (index, item) in items.enumerated() {
            let rect = columnsPath[index]
            let rectanglePath = UIBezierPath(rect: rect)
            item.color.setFill()
            rectanglePath.fill()
        }
    }
    
    // MARK: - Public Methods
    
    func addChart(data: ChartData) {
        charts.append(data)
    }
    
    func startAnimation() {
        timerDelay?.invalidate()
        isUserInteractionEnabled = true
        timerDelay = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
            self.changeChartWithAnimation()
        })
    }
    
    func stopAnimation() {
        isUserInteractionEnabled = false
        timerDelay?.invalidate()
    }
    
    // MARK: - Private Methods
    
    private func convertValueToHeight(value: CGFloat) -> CGFloat {
        return bounds.height / CGFloat(ChartItem.maxValue - ChartItem.minValue) * value
    }
    
    private func setupColumnsPath(withZeroHeight zeroHeight: Bool = false) {
        if charts.isEmpty { return }
        let items = charts[currentChartIndex].items
        
        columnsPath.removeAll()
        for (index, item) in items.enumerated() {
            let rect = CGRect(x: CGFloat(index) * (columnWidth + CGFloat(distanceBetweenColumns)),
                              y: self.bounds.height,
                              width: columnWidth,
                              height: zeroHeight ? 0 : -convertValueToHeight(value: CGFloat(item.value)))
            columnsPath.append(rect)
        }
    }
    
    private func changeChartWithAnimation() {
        if charts.isEmpty { return }
        
        let currentItems = charts[currentChartIndex].items
        let deltasForCurrentChart = currentItems.map({
            convertValueToHeight(value: CGFloat($0.value / (animationDuration / 2 * animationFPS)))
        })
        
        let nextItems = currentChartIndex < charts.count - 1 ? charts[currentChartIndex + 1].items : charts[0].items
        let deltasForNextChart = nextItems.map({
            convertValueToHeight(value: CGFloat($0.value / (animationDuration / 2 * animationFPS)))
        })
        
        var repeatCount = Int(animationDuration * animationFPS)
        let midRepeatCount = repeatCount / 2
        stopAnimation()
        
        Timer.scheduledTimer(withTimeInterval: 1 / animationFPS, repeats: true, block: { timer in
            for (index, path) in self.columnsPath.enumerated() {
                let delta = repeatCount > midRepeatCount ? deltasForCurrentChart[index] : -deltasForNextChart[index]
                let newRect = CGRect(origin: path.origin, size: CGSize(width: path.width, height: -path.height + delta))
                self.columnsPath[index] = newRect
                    
            }
            repeatCount -= 1
            
            if repeatCount == midRepeatCount {
                self.currentChartIndex = self.currentChartIndex < self.charts.count - 1 ? self.currentChartIndex + 1 : 0
                self.setupColumnsPath(withZeroHeight: true)
            }
            
            if repeatCount == 0 {
                timer.invalidate()
                self.setupColumnsPath()
                self.startAnimation()
            }
            
            self.setNeedsDisplay()
        })
    }

}
