//
//  SafetyQuestionnaireScreen.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 6/6/25.
//

import Foundation
import SwiftUI

struct SafetyQuestionnaireScreen: View {
    @ObservedObject var viewModel: QuestionnaireViewModel
    @Binding var path: NavigationPath
    
    @State var selectedIsSelfHarm: Bool? = nil
    @State var selectedIsNeedHelp: Bool? = nil
    @State var selectedIsTalkToTherapist: Bool? = nil
    
    private var isFormValid: Bool {
        selectedIsSelfHarm != nil && selectedIsNeedHelp != nil && selectedIsTalkToTherapist != nil
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Did you have any thoughts of self-harm or suicide today?")) {
                    HStack {
                        Text("True")
                        Spacer()
                        Image(systemName: selectedIsSelfHarm == true ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                    }
                    .onTapGesture {
                        selectedIsSelfHarm = true
                    }
                    HStack {
                        Text("False")
                        Spacer()
                        Image(systemName: selectedIsSelfHarm == false ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                    }
                    .onTapGesture {
                        selectedIsSelfHarm = false
                    }
                }
                Section(header: Text("Do you feel like you need help or support today?")) {
                    HStack {
                        Text("True")
                        Spacer()
                        Image(systemName: selectedIsNeedHelp == true ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                    }
                    .onTapGesture {
                        selectedIsNeedHelp = true
                    }
                    HStack {
                        Text("False")
                        Spacer()
                        Image(systemName: selectedIsNeedHelp == false ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                    }
                    .onTapGesture {
                        selectedIsNeedHelp = false
                    }
                }
                Section(header: Text("Would you like to talk to a therapist or counselor?")) {
                    
                    HStack {
                        Text("True")
                        Spacer()
                        Image(systemName: selectedIsTalkToTherapist == true ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                    }
                    .onTapGesture {
                        selectedIsTalkToTherapist = true
                    }
                    HStack {
                        Text("False")
                        Spacer()
                        Image(systemName: selectedIsTalkToTherapist == false ? "largecircle.fill.circle" : "circle").foregroundColor(.blue)
                    }
                    .onTapGesture {
                        selectedIsTalkToTherapist = false
                    }
                }
            }
            Button {
                viewModel.saveSafetySection(selectedIsSelfHarm: selectedIsSelfHarm, selectedIsNeedHelp: selectedIsNeedHelp, selectedIsTalkToTherapist: selectedIsTalkToTherapist)
                viewModel.showCompletion = true
                path.removeLast(path.count)
            } label: {
                Text("Complete").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])
            .disabled(!isFormValid)
        }
        .navigationTitle("Safety & Support")
        .onAppear
        {
            if let existing = viewModel.todayQuestionnaire {
                if existing.safetySectionComplete == false {
                    selectedIsSelfHarm = nil
                    selectedIsNeedHelp = nil
                    selectedIsTalkToTherapist = nil
                } else {
                    selectedIsSelfHarm = existing.isSelfHarm
                    selectedIsNeedHelp = existing.isNeedHelp
                    selectedIsTalkToTherapist = existing.isTalkToTherapist
                }
            }
        }
    }
}

