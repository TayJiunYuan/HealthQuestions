//
//  InsightsScreen.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 10/6/25.
//

import SwiftUI
import Charts

struct InsightsScreen: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    @State private var selectedOption: Option = .moodRating
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
    @State private var endDate: Date   = Date()
    
    var body: some View {
        VStack(spacing: 24) {
            
            Picker("Metric", selection: $selectedOption) {
                Text("Mood").tag(Option.moodRating)
                Text("Anxiety").tag(Option.anxietyLevel)
                Text("Sleep").tag(Option.sleepLevel)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            HStack {
                DatePicker("From", selection: $startDate, displayedComponents: .date)
                DatePicker("To", selection: $endDate,   displayedComponents: .date)
            }
            .padding(.horizontal)
            
            Chart {
                ForEach(viewModel.individualInsightsData, id: \.0) { point in
                    LineMark(
                        x: .value("Date",  point.0),
                        y: .value("Rating", point.1)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(color(for: selectedOption))
                    .symbol(Circle())          // optional point symbol
                }
            }
            .chartXAxisLabel("Date")
            .chartYAxisLabel("Level")
            .frame(height: 300)
            .padding(.horizontal)
        }
        .navigationTitle("Insights")
        .onAppear {
            viewModel.reloadIndividualInsights(selectedOption: selectedOption, startDate: startDate, endDate: endDate)
        }
        .onChange(of: selectedOption) {
            viewModel.reloadIndividualInsights(selectedOption: selectedOption, startDate: startDate, endDate: endDate)
        }
        .onChange(of: startDate) {
            viewModel.reloadIndividualInsights(selectedOption: selectedOption, startDate: startDate, endDate: endDate)
        }
        .onChange(of: endDate) {
            viewModel.reloadIndividualInsights(selectedOption: selectedOption, startDate: startDate, endDate: endDate)
        }
    }
    
    
    private func color(for option: Option) -> Color {
        switch option {
        case .moodRating:   return .blue
        case .anxietyLevel: return .red
        case .sleepLevel:   return .green
        case .all:          return .gray
        }
    }
}
