//
//  SleepQuestionnaireScreen.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 6/6/25.
//

import Foundation
import SwiftUI

struct SleepQuestionnaireScreen: View {
    @ObservedObject var viewModel: QuestionnaireViewModel
    @Binding var path: NavigationPath
    @State private var errorMessage: String? = nil
    
    @State private var selectedSleepHours: String = ""
    @State private var selectedSleepOrdinal: SleepOrdinal? = nil
    @State private var selectedEnergyLevel: Double = 5
    
    private var isFormValid: Bool {
        selectedSleepHours != "" && selectedSleepOrdinal != nil
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("How many hours did you sleep last night?")) {
                    TextField("Eg. 8", text: $selectedSleepHours)
                }
                Section(header: Text("How was your sleep quality?")) {
                    ForEach(SleepOrdinal.allCases) {
                        sleepOrdinal in
                        HStack {
                            Text(sleepOrdinal.rawValue)
                            Spacer()
                            Image(systemName: selectedSleepOrdinal == sleepOrdinal ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                        }
                        .onTapGesture {
                            selectedSleepOrdinal = sleepOrdinal
                        }
                    }
                }
                Section(header: Text("Energy level today (0 = none, 10 = high)")) {
                    HStack {
                        Slider(value: $selectedEnergyLevel, in: 0...10, step: 1)
                        Text("\(Int(selectedEnergyLevel))")
                            .frame(width: 30, alignment: .leading)
                    }
                }
            }
            Text(errorMessage ?? "")
            Button {
                errorMessage = ""
                if Double(selectedSleepHours) == nil {
                    errorMessage = "Hours of sleep must be a number"
                } else {
                    viewModel.saveSleepSection(selectedSleepHours: selectedSleepHours, selectedSleepOrdinal: selectedSleepOrdinal, selectedEnergyLevel: selectedEnergyLevel)
                    path.append(AppScreen.safetyQuestionnaireScreen)
                }
            } label: {
                Text("Save and Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])
            .disabled(!isFormValid)
        }
        .navigationTitle("Sleep & Energy")
        .onAppear{
            if let existing = viewModel.todayQuestionnaire {
                selectedSleepOrdinal = SleepOrdinal(rawValue: existing.sleepOrdinal ?? "")
                selectedEnergyLevel = existing.energyLevel
                if existing.sleepSectionComplete == true {
                    selectedSleepHours = String(existing.sleepHours)
                } else {
                    selectedSleepHours = ""
                }
            }
        }
    }
}
