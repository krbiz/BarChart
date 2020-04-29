//
//  CharData.swift
//  BarChart
//
//  Created by Dima Krupskyi on 28.04.2020.
//  Copyright © 2020 Dima Krupskyi. All rights reserved.
//

import UIKit

struct ChartData {
    
    var items: [ChartItem] = []
    
    init(items: [ChartItem]) {
        self.items = items
    }
    
    static func randomData() -> ChartData {
        var titles = ["Kiev", "Lviv", "Odessa", "Poltava", "Ternopil", "Lutsk", "Sumy"]
        var colors: [UIColor] = [.red, .green, .purple, .brown, .magenta, .blue, .orange]
        let values = (0...6).map({ _ in Double.random(in: 0...100) })
        
        titles.shuffle()
        colors.shuffle()
        
        let randomItems: [ChartItem] = (0...6).map { i in
            ChartItem(title: titles[i], value: values[i], color: colors[i])
        }
        
        return ChartData(items: randomItems)
    }
    
    static func randomData1() -> ChartData {
        var titles = ["Kiev", "Lviv", "Odessa", "Poltava", "Ternopil", "Lutsk", "Sumy"]
        var colors: [UIColor] = [.red, .green, .purple, .brown, .magenta, .blue, .orange]
        let values = (0...6).map({ _ in Double.random(in: 0...100) })
        
        titles.shuffle()
        colors.shuffle()
        
        let randomItems: [ChartItem] = (0...4).map { i in
            ChartItem(title: titles[i], value: values[i], color: colors[i])
        }
        
        return ChartData(items: randomItems)
    }
}
