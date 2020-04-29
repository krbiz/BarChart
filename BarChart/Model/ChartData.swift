//
//  CharData.swift
//  BarChart
//
//  Created by Dima Krupskyi on 28.04.2020.
//  Copyright © 2020 Dima Krupskyi. All rights reserved.
//

import UIKit

struct ChartItem {
    
    static let minValue = 0.0
    static let maxValue = 100.0
    
    let title: String
    var value: Double
    let color: UIColor
}

struct ChartData {
    
    var items: [ChartItem] = []
    
    static func randomData() -> ChartData {
        var titles = ["Kiev", "Lviv", "Odessa", "Poltava", "Ternopil", "Lutsk", "Sumy", "Zhytomyr"]
        var colors: [UIColor] = [.red, .green, .purple, .brown, .magenta, .blue, .orange, .cyan]
        let values = (0...7).map({ _ in Double.random(in: ChartItem.minValue...ChartItem.maxValue) })
        
        titles.shuffle()
        colors.shuffle()
        
        let randomItems: [ChartItem] = (0...Int.random(in: 4...7)).map { i in
            ChartItem(title: titles[i], value: values[i], color: colors[i])
        }
        
        return ChartData(items: randomItems)
    }
    
    mutating func addItem(_ item: ChartItem) {
        items.append(item)
    }
    
}
