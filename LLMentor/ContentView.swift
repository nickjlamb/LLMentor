import SwiftUI

// Custom Color Extensions
extension Color {
    static let bluePrimary = Color(red: 32/255, green: 54/255, blue: 245/255)
    static let purpleAccent = Color(red: 137/255, green: 88/255, blue: 254/255)
    static let customCyan = Color(red: 70/255, green: 205/255, blue: 255/255)
}

// Haptic Feedback Manager
class HapticManager {
    static let shared = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct RadioButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.shared.impact(style: .light)
            action()
        }) {
            HStack(spacing: 8) {
                Circle()
                    .strokeBorder(isSelected ? Color.bluePrimary : .gray, lineWidth: 2)
                    .background(Circle().foregroundColor(isSelected ? Color.bluePrimary : .clear))
                    .frame(width: 20, height: 20)
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct UtilityButton: View {
    let systemName: String
    let action: () -> Void
    var isAnimating: Bool = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(style: .light)
            action()
        }) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
                .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                .animation(isAnimating ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isAnimating)
        }
    }
}

struct CharacterCounter: View {
    let currentCount: Int
    let limit: Int
    
    var body: some View {
        Text("\(currentCount)/\(limit)")
            .font(.caption)
            .foregroundColor(currentCount > limit ? .red : .gray)
            .padding(.trailing, 8)
    }
}

struct ToastView: View {
    let message: String
    let isSuccess: Bool
    
    var body: some View {
        Text(message)
            .font(.footnote)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSuccess ? Color.gray.opacity(0.9) : Color.red.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

struct ContentView: View {
    @State private var showIntro = false
    @State private var showAbout = false  // Add this at the top with other @State vars
    @State private var selectedLanguage = "English"
    @State private var inputText = ""
    @State private var selectedAudience = "Adult patient"
    @State private var selectedTone = "Confident"
    @State private var outputText = "Your optimised text will appear here."
    @State private var isLoading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isRefreshing = false
    @State private var isSuccess = true
    
    let characterLimit = 500

    let languages = [
        "English",
        "Español",
        "Deutsch",
        "Français",
        "Italiano",
        "中文 (Mandarin)",
        "العربية (Arabic)",
        "हिन्दी (Hindi)",
        "日本語 (Japanese)",
        "Português (Portuguese)",
        "Русский (Russian)"
    ]
    
    let audiences = [
        "Child",
        "Teenager",
        "Adult patient",
        "Carer",
        "Nurse",
        "Pharmacist",
        "Doctor",
        "Specialist",
        "Payer",
        "MSL"
    ]
    
    let audiencePrompts: [String: String] = [
        "Child": "Explain this medical concept as if talking to a 7-year-old child. Use very simple words, short sentences, and fun analogies. Avoid any scary or complex medical terms:",
        "Teenager": "Explain this medical information to a teenager. Use language that's clear but not condescending, relate to their experiences when possible, and focus on how this information might be relevant to their daily life or future health:",
        "Adult patient": "Explain this medical information to an adult patient with no medical background. Use everyday language, provide context for any necessary medical terms, and focus on what the patient needs to know for their health:",
        "Carer": "Adapt this medical information for a family caregiver. Focus on practical care instructions, signs to watch for, and when to seek professional help. Include tips for managing care and self-care for the caregiver:",
        "Nurse": "Present this medical information for a registered nurse. Use professional terminology, focus on patient care aspects, treatment protocols, and potential complications to monitor:",
        "Pharmacist": "Adjust this medical information for a pharmacist. Highlight medication-related aspects, potential drug interactions, dosing considerations, and key points for patient counseling:",
        "Doctor": "Summarize this medical information for a general practitioner. Use medical terminology, focus on diagnosis, treatment options, and when to refer to specialists:",
        "Specialist": "Elaborate on this medical information for a specialist in the relevant field. Include detailed physiological processes, latest treatment protocols, recent research findings, and potential areas for further investigation:",
        "Payer": "Summarize this medical information for a healthcare payer or insurance professional. Focus on cost implications, treatment effectiveness, potential for cost savings, and impact on long-term health outcomes:",
        "MSL": "Expand on this medical information for a Medical Science Liaison. Include recent clinical trial data, regulatory considerations, comparisons with current standards of care, and potential impacts on treatment guidelines:"
    ]
    
    let tones = [
           "Confident",
           "Friendly",
           "Scientific",
           "Persuasive",
       ]
       
       let tonePrompts: [String: String] = [
           "Confident": "Deliver the message in a confident tone.",
           "Friendly": "Make the message sound friendly and approachable.",
           "Scientific": "Use a scientific tone, focusing on data and precision.",
           "Persuasive": "Present the message in a persuasive way to convince the reader.",
       ]
    
    var isInputValid: Bool {
           !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
           inputText.count <= characterLimit
       }
    
    func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        func showToastMessage(_ message: String, isSuccess: Bool = true) {
            toastMessage = message
            self.isSuccess = isSuccess
            showToast = true
            
            // Haptic feedback
            HapticManager.shared.notification(type: isSuccess ? .success : .error)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showToast = false
            }
        }
    
    func generateOutput() {
            dismissKeyboard() // Dismiss the keyboard
            guard isInputValid else {
                if inputText.isEmpty {
                    showToastMessage("Please enter some text", isSuccess: false)
                } else {
                    showToastMessage("Text exceeds 500 characters", isSuccess: false)
                }
                return
            }
            
            isLoading = true
            let audiencePrompt = audiencePrompts[selectedAudience] ?? ""
            let tonePrompt = tonePrompts[selectedTone] ?? ""
            
            APIService.shared.optimiseText(
                inputText: "\(audiencePrompt) \(tonePrompt) \(inputText)",
                language: selectedLanguage,
                audience: selectedAudience,
                tone: selectedTone
            ) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    isRefreshing = false
                    
                    switch result {
                    case .success(let text):
                        outputText = text
                        if !isRefreshing {
                            showToastMessage("Text optimised successfully")
                        }
                    case .failure(let error):
                        outputText = "Error: \(error.localizedDescription)"
                        showToastMessage("Failed to optimise text", isSuccess: false)
                    }
                }
            }
        }

    var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Updated Header Section
                        VStack(spacing: 8) {
                            Text("Optimise medical text for any audience")
                                .font(.system(size: 24, weight: .bold)) // Updated font size and weight
                                .multilineTextAlignment(.center)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.bluePrimary, Color.bluePrimary.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                        .padding(.top, 12)
                        
                    // Language Picker
                    Picker("", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.customCyan.opacity(0.2))
                    .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 4) {
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $inputText)
                                    .frame(height: 150)
                                    .padding(4) // Match padding to align cursor and placeholder
                                    .background(Color(uiColor: .systemBackground))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.purpleAccent.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                                
                                if inputText.isEmpty {
                                    Text("Enter your medical text here...")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 8)  // Adjust padding for alignment
                                        .padding(.top, 12)      // Adjust padding for alignment
                                }
                            }
                            HStack {
                                Spacer()
                                CharacterCounter(currentCount: inputText.count, limit: characterLimit)
                            }
                        }
                                    
                    // Add this after the Input Text Area with Character Counter
                    // Audience Picker
                    Picker("", selection: $selectedAudience) {
                        ForEach(audiences, id: \.self) { audience in
                            Text(audience)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.customCyan.opacity(0.2))
                    .cornerRadius(12)
                    
                    // Tone Selection
                    VStack(spacing: 8) {
                        Text("Tone")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 24) {
                                RadioButton(label: "Confident", isSelected: selectedTone == "Confident") {
                                    selectedTone = "Confident"
                                }
                                RadioButton(label: "Friendly", isSelected: selectedTone == "Friendly") {
                                    selectedTone = "Friendly"
                                }
                            }
                            
                            HStack(spacing: 24) {
                                RadioButton(label: "Scientific", isSelected: selectedTone == "Scientific") {
                                    selectedTone = "Scientific"
                                }
                                RadioButton(label: "Persuasive", isSelected: selectedTone == "Persuasive") {
                                    selectedTone = "Persuasive"
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                        // Output Area with Utility Buttons
                        VStack(alignment: .leading, spacing: 16) {
                            ZStack {
                                VStack(spacing: 12) {
                                    if isLoading {
                                        HStack {
                                            Spacer()
                                            ProgressView("Optimising text...")
                                                .tint(Color.bluePrimary)
                                            Spacer()
                                        }
                                    } else {
                                        Text(outputText)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(uiColor: .systemBackground))
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.purpleAccent.opacity(0.3), lineWidth: 1)
                                            )
                                        
                                        HStack(spacing: 16) {
                                            UtilityButton(systemName: "doc.on.doc") {
                                                if !outputText.isEmpty && outputText != "Your optimised text will appear here." {
                                                    UIPasteboard.general.string = outputText
                                                    showToastMessage("Copied to clipboard")
                                                }
                                            }
                                            
                                            UtilityButton(systemName: "arrow.clockwise", action:  {
                                                if isInputValid {
                                                    isRefreshing = true
                                                    generateOutput()
                                                }
                                            }, isAnimating: isRefreshing)
                                            
                                            UtilityButton(systemName: "trash") {
                                                withAnimation {
                                                    inputText = ""
                                                    outputText = "Your optimised text will appear here."
                                                    selectedTone = "Confident"
                                                    selectedAudience = "Adult patient"
                                                    selectedLanguage = "English"
                                                    showToastMessage("All fields cleared")
                                                }
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                }
                                
                                if showToast {
                                    ToastView(message: toastMessage, isSuccess: isSuccess)
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                        .animation(.easeInOut(duration: 0.3), value: showToast)
                                }
                            }
                        }
                        .frame(minHeight: 100)

                        // Disclaimer
                        Text("This tool uses AI. Please check for mistakes.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .padding(.horizontal)
                            .padding(.bottom, 16) // Add space at the bottom to separate from other elements

                        // Generate Button
                                            Button(action: generateOutput) {
                                                Text("Generate Output")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 16)
                                            }
                                            .background(Color.bluePrimary)
                                            .cornerRadius(12)
                                            .padding(.horizontal, 24)
                                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                            .disabled(!isInputValid)
                                            .opacity(isInputValid ? 1 : 0.7)
                                        }
                                        .padding()
                                    }
                                    .background(Color(uiColor: .systemBackground))
                                    .navigationBarItems(trailing:
                                        HStack(spacing: 16) {
                                            Button(action: {
                                                showAbout = true
                                            }) {
                                                Image(systemName: "info.circle")
                                                    .foregroundColor(Color.bluePrimary)
                                            }
                                            Button(action: {
                                                showIntro = true
                                            }) {
                                                Image(systemName: "questionmark.circle")
                                                    .foregroundColor(Color.bluePrimary)
                                            }
                                        }
                                    )
                                    .sheet(isPresented: $showIntro) {
                                        IntroView {
                                            showIntro = false
                                        }
                                    }
                                    .sheet(isPresented: $showAbout) {
                                        AboutView()
                                    }
                                    }
                                }
                            }
                        

                   #Preview {
                       ContentView()
                   }
