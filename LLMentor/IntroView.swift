import SwiftUI

struct IntroView: View {
    var dismissAction: (() -> Void)?
    @State private var selectedStep: Int? = nil
    @State private var titleOpacity = 0.0
    @State private var descriptionOpacity = 0.0
    @State private var stepsOpacity = 0.0
    @State private var buttonOpacity = 0.0

    struct Step: Identifiable {
        let id = UUID()
        let number: Int
        let title: String
        let description: String
        let icon: String
    }

    let steps = [
        Step(number: 1,
             title: "Select language",
             description: "Choose from 11 different languages",
             icon: "globe"),
        Step(number: 2,
             title: "Enter your text",
             description: "Type or paste any medical text you want",
             icon: "pencil"),
        Step(number: 3,
             title: "Choose audience & tone",
             description: "Select who will read it and how it should sound",
             icon: "person.2.fill"),
        Step(number: 4,
             title: "Get optimised text",
             description: "Generate and copy your perfectly adapted text",
             icon: "sparkles")
    ]

    var body: some View {
        VStack {
            // Main content with flexible spacing
            VStack(spacing: 16) {  // Adjusted spacing
                // Top logo section
                Image("pharmatools-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)  // Small size for subtlety
                    .padding(.top, 40) // Space from top
                    .opacity(titleOpacity)
                
                // Welcome section
                VStack(spacing: 16) {
                    Text("Welcome to LLMentor")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.bluePrimary, Color.bluePrimary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Your AI-powered medical writing assistant.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32) // Added padding here
                }
                .opacity(descriptionOpacity)
                .padding(.top, 20)
                
                // Steps section
                VStack(spacing: 8) { // Reduced from 16
                    Text("How the app works:")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 4) // Reduced from 8

                    ForEach(steps) { step in
                        VStack(spacing: 0) {
                            StepCardView(
                                step: step,
                                isSelected: selectedStep == step.number
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedStep = step.number
                                }
                            }
                            
                            // Shorter connector line
                            if step.number < steps.count {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.bluePrimary.opacity(0.2), Color.bluePrimary.opacity(0.1)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 1, height: 16) // Reduced from 20
                                    .padding(.vertical, 4) // Reduced from 8
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .opacity(stepsOpacity)
            }

            Spacer()

            // Button section anchored to bottom
            Button(action: {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()

                withAnimation(.easeInOut(duration: 0.3)) {
                    buttonOpacity = 0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dismissAction?()
                }
            }) {
                HStack {
                    Text("Get Started")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color.bluePrimary, Color.bluePrimary.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.bluePrimary.opacity(0.3), radius: 15, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .opacity(buttonOpacity)
        }
        .background(Color(uiColor: .systemBackground))
        .onAppear {
            print("Debug: Title opacity starting value: \(titleOpacity)")
            
            withAnimation(.easeOut(duration: 0.6)) {
                titleOpacity = 1
                print("Debug: Title opacity animated to: \(titleOpacity)")
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                descriptionOpacity = 1
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                stepsOpacity = 1
            }

            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.9)) {
                buttonOpacity = 1
            }
        }
    }
}

struct StepCardView: View {
    let step: IntroView.Step
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Step number with icon
            ZStack {
                Circle()
                    .fill(isSelected ? Color.bluePrimary : Color.bluePrimary.opacity(0.1))
                    .frame(width: 36, height: 36)

                Image(systemName: step.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .white : Color.bluePrimary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.system(size: 17, weight: .semibold))
                Text(step.description)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color.bluePrimary.opacity(0.3) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    IntroView()
}
