//
//  LLMentorApp.swift
//  LLMentor
//
//  Created by Nick Lamb on 18/11/2024.
//

import SwiftUI

@main
struct LLMentorApp: App {
    @State private var showIntro: Bool = true // Always show intro on app launch

    var body: some Scene {
        WindowGroup {
            if showIntro {
                IntroView {
                    showIntro = false // Hide intro after dismissing
                }
            } else {
                ContentView()
            }
        }
    }
}
