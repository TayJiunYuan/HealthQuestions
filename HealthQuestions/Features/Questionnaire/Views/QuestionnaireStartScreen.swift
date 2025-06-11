//
//  QuestionnaireStartScreenn.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 4/6/25.
//

import Foundation
import SwiftUI

struct QuestionnaireStartScreen: View {
    @ObservedObject var viewModel: QuestionnaireViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(){
            Text("Hey! How are you doing today? Our daily questionnaire consists of question from several topics that allows us to understand you better and track your mood! ")
            Button("Next") {
                path.append(AppScreen.moodQuestionnaireScreen)
            }
        }
        .navigationTitle("Daily Questionnaire")
        .onAppear(perform: {viewModel.fetchTodayQuestionnaire()}) // Freeze date on appear on this screen. Eg. if the user comes into this screen at 11.59PM Tues, the form will fill for Tues instead of Wed even if he/she takes more than 1 minute to complete
    }
}
