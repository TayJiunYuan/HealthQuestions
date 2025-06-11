//
//  HealthQuestionsApp.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 3/6/25.
//

import SwiftUI

@main

struct HealthQuestionsApp: App {
    let provider = CoreDataProvider.shared
    @StateObject private var questionnaireViewModel = QuestionnaireViewModel()
    @StateObject private var insightsViewModel = InsightsViewModel()
    @State private var path = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path)  {
                ContentView(questionnaireViewModel: questionnaireViewModel, insightsViewModel: insightsViewModel, path: $path).environment(\.managedObjectContext, provider.context)
                    .navigationDestination(for: AppScreen.self) {
                        screen in
                        switch screen {
                        case .questionnaireStartScreen:
                            QuestionnaireStartScreen( viewModel: questionnaireViewModel, path: $path)
                        case .moodQuestionnaireScreen:
                            MoodQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                        case .anxietyQuestionnaireScreen:
                            AnxietyQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                        case .sleepQuestionnaireScreen:
                            SleepQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                        case .safetyQuestionnaireScreen:
                            SafetyQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                        case .insightsScreen:
                            InsightsScreen(viewModel: insightsViewModel)
                        }
                    }
            }
        }
    }
}
