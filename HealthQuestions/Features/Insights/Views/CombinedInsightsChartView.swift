//
//  CombinedInsightsChartView.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 8/6/25.
//

import SwiftUI
import Charts

struct CombinedInsightsChartView: View {
    @ObservedObject var insightsViewModel: InsightsViewModel
    
    var body: some View {
        Chart {
            ForEach(Array(Dictionary(grouping: insightsViewModel.allInsightsData, by: { $0.0 }).keys), id: \.self) { option in  // [TODO] Better way to represting the Options
                let optionData = insightsViewModel.allInsightsData.filter { $0.0 == option }
                ForEach(optionData, id: \.1) { entry in
                    LineMark(
                        x: .value("Date", entry.1),
                        y: .value("Rating", entry.2)
                    )
                    .foregroundStyle(by: .value("Category", option.rawValue))
                    .symbol(by: .value("Category", option.rawValue))
                }
            }
        }
        .chartXAxisLabel("Date")
        .chartYAxisLabel("Rating")
        .frame(height: 300)
        .onAppear {
            insightsViewModel.fetchInsightsForAllForPastWeek()
        }
    }
}
