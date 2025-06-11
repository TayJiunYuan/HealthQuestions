//
//  ContentView.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 3/6/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var questionnaireViewModel: QuestionnaireViewModel
    @ObservedObject var insightsViewModel: InsightsViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Welcome Back!").font(.largeTitle)
                Spacer()
                Text("Here are some inspiring quotes for you!")
                QuoteHorizontalScrollView()
                Spacer()
                Text("Quick Links")
                QuickLinksHorizontalView(questionnaireViewModel: questionnaireViewModel, insightsViewModel: insightsViewModel, path: $path)
                Spacer()
                Text("This week's insights")
                CombinedInsightsChartView(insightsViewModel: insightsViewModel)
            }.padding()
        }
        .alert("Thank you for checking in!",
               isPresented: $questionnaireViewModel.showCompletion) {
            Button("OK") {
                questionnaireViewModel.showCompletion = false
            }
        } message: {
            if questionnaireViewModel.isAtRisk {
                Text("""
                    If you're feeling overwhelmed, please consider reaching out to someone you trust —
                    a loved one, friend, or someone who will listen. Talking helps.
                    
                    You can also find professional support near you at findahelpline.com.
                    
                    There's always help available.
                    """)
                .multilineTextAlignment(.leading)
            } else {
                Text("Your response have been saved succesfully.")
            }
        }
    }
}

