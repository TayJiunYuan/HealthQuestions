//
//  AnxietyQuestionnaireScreen.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 6/6/25.
//

import Foundation
import SwiftUI

struct AnxietyQuestionnaireScreen: View {
    @ObservedObject var viewModel: QuestionnaireViewModel
    @Binding var path: NavigationPath
    
    @State private var selectedAnxietyOrdinal: AnxietyOrdinal? = nil
    @State private var selectedAnxietyLevel: Double = 5
    @State private var selectedAnxietyTrigger: String = ""
    
    private var isFormValid: Bool {
        selectedAnxietyOrdinal != nil
    }
    
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Did you feel anxious or stressed today?")) {
                    ForEach(AnxietyOrdinal.allCases) {
                        anxietyOrdinal in
                        HStack {
                            Text(anxietyOrdinal.rawValue)
                            Spacer()
                            Image(systemName: selectedAnxietyOrdinal == anxietyOrdinal ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                        }
                        .onTapGesture {
                            selectedAnxietyOrdinal = anxietyOrdinal
                        }
                    }
                }
                Section(header: Text("Anxiety level (0 = none, 10 = extreme)")) {
                    HStack {
                        Slider(value: $selectedAnxietyLevel, in: 0...10, step: 1)
                        Text("\(Int(selectedAnxietyLevel))")
                            .frame(width: 30, alignment: .leading)
                    }
                }
                Section(header: Text("What triggered your stress or anxiety today (if anything)")) {
                    TextField("Eg. Work", text: $selectedAnxietyTrigger)
                }
            }
            Button {
                viewModel.saveAnxietySection(selectedAnxietyOrdinal: selectedAnxietyOrdinal, selectedAnxietyLevel: selectedAnxietyLevel, selectedAnxietyTrigger: selectedAnxietyTrigger)
                path.append(AppScreen.sleepQuestionnaireScreen)
            } label: {
                Text("Save and Continue").frame(maxWidth: .infinity)
            } .buttonStyle(.borderedProminent)
                .padding([.horizontal, .bottom])
                .disabled(!isFormValid)
        }
        .navigationTitle("Anxiety & Stress")
        .onAppear {
            if let existing = viewModel.todayQuestionnaire {
                selectedAnxietyOrdinal = AnxietyOrdinal(rawValue: existing.anxietyOrdinal ?? "")
                selectedAnxietyLevel = existing.anxietyLevel
                selectedAnxietyTrigger = existing.anxietyTrigger ?? ""
            }
        }
    }
}
