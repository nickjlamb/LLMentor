//
//  AboutView.swift
//  LLMentor
//
//  Created by Nick Lamb on 19/11/2024.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Main List Content
                List {
                    // App Info Section
                    Section {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text(appVersion)
                                .foregroundColor(.gray)
                        }
                        
                        Link(destination: URL(string: "mailto:info@pharmatools.ai")!) {
                            HStack {
                                Text("Contact")
                                Spacer()
                                Text("info@pharmatools.ai")
                                    .foregroundColor(.gray)
                            }
                        }
                    } header: {
                        Text("App Info")
                    }
                    
                    // Legal Section
                    Section {
                        NavigationLink {
                            AboutPrivacyView()
                        } label: {
                            Text("Privacy Policy")
                        }
                        
                        NavigationLink {
                            AboutTermsView()
                        } label: {
                            Text("Terms of Use")
                        }
                    } header: {
                        Text("Legal")
                    }
                    
                    // Credits Section
                    Section {
                        Link("PharmaTools.AI", destination: URL(string: "https://pharmatools.ai")!)
                        Text("© 2024 PharmaTools.AI")
                    } header: {
                        Text("Credits")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                /// Footer with Logo and Tagline
                VStack(spacing: 4) { // Tighter spacing for closer alignment
                    // Logo positioned at the top of the footer
                    Link(destination: URL(string: "https://pharmatools.ai")!) {
                        Image("pharmatools-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)
                            .padding(.bottom, 4) // Small space below the logo
                    }

                    // Tagline immediately below the logo
                    Text("Empowering Pharma and MedComms with AI Solutions")
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)

                    // Hyperlink to explore tools, with some separation below tagline
                    Text("Explore more tools on PharmaTools.AI")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 8) // Space between tagline and link
                        .onTapGesture {
                            if let url = URL(string: "https://pharmatools.ai") {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                .padding(.top, 16) // Space above the footer section
                .padding(.bottom, 20) // Space below the entire footer
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

struct AboutPrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .bold()
                
                Text("Last updated: November 19, 2024")
                    .foregroundColor(.gray)
                
                Text("Your Privacy Matters")
                    .font(.headline)
                
                Text("""
               We are committed to protecting your privacy. This policy outlines how we collect, use, and safeguard your data.
               
               Information We Collect:
               • Text input for optimisation
               • App usage analytics
               • Device information
               
               How We Use Your Information:
               • To provide text optimisation services
               • To improve app functionality
               • To resolve bugs and technical issues
               • To monitor the usage of our services
               • To enhance the performance of our AI tools
               
               Data Storage:
               • Data inputs and outputs are processed in real-time and not stored after processing is complete.
               • No personal data is retained unless explicitly stated.
               • Anonymised, aggregated data may be used to improve our AI tools and services.
               
               Third-Party Services:
               We use AI services, such as OpenAI’s API, to optimise your text. These services adhere to strict privacy standards and do not store your content. Additionally, Captcha services may collect information such as your IP address, browser data, and usage patterns, which are subject to their privacy policies.
               
               Your Rights:
               • Access, update, or delete your information
               • Request data deletion
               • Opt out of analytics
               • Withdraw consent for data processing
               
               Automated Decision-Making:
               LLMentor utilises AI-powered tools to assist with text optimisation. These tools are designed to aid decision-making and are not a substitute for professional judgement. Always verify AI-generated outputs.
               
               Data Security:
               We have implemented appropriate technical and organisational measures to secure your personal information. However, no method of electronic transmission or storage is entirely secure.
               
               Contact Us:
               If you have any questions about this policy, please email us at info@pharmatools.ai.
               """)
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct AboutTermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Use")
                    .font(.title)
                    .bold()
                
                Text("Last updated: 19 November 2024")
                    .foregroundColor(.gray)
                
                Text("""
               By using LLMentor, you agree to these Terms of Use:
               
               1. Agreement to Terms
               By accessing and using LLMentor, you agree to these Terms. If you do not accept these Terms, you must not use the app or its services.
               
               2. Changes to Terms
               We reserve the right to update these Terms at any time. The latest version will always be available within the app. Continued use of LLMentor after changes take effect indicates acceptance of the updated Terms.
               
               3. Privacy Policy
               Your use of LLMentor is subject to our Privacy Policy, which outlines how we collect, process, and safeguard your data.
               
               4. Acceptable Use
               You may only use LLMentor for lawful purposes, including:
               • Optimising medical text for professional communication.
               • Generating text adaptations for specific audiences and tones.
               
               You must not:
               • Use the app for harmful, illegal, or unethical purposes.
               • Submit confidential patient data or sensitive personal information.
               
               5. User Responsibilities
               • You are responsible for verifying the accuracy of AI-generated content.
               • Always review and validate outputs for compliance with applicable laws and professional standards.
               
               6. Service Limitations
               • Outputs are generated using AI and may vary in accuracy or quality.
               • LLMentor is a tool to assist your writing, not a substitute for professional judgement or regulatory compliance.
               • Service availability and features may change without notice.
               
               7. Data Processing
               • Inputs are processed in real-time and not stored after processing is complete.
               • Do not submit sensitive or confidential data.
               • Anonymised, aggregated data may be used to improve app performance.
               
               8. Intellectual Property
               • You retain rights to the content you input and generate.
               • The AI processing technology is proprietary to LLMentor.
               
               9. Disclaimer of Warranties
               The app is provided "as is" without warranties of any kind. We make no guarantees regarding the accuracy, reliability, or fitness for a particular purpose of the app or its outputs.
               
               10. Limitation of Liability
               We are not liable for any direct, indirect, incidental, or consequential damages arising from your use or inability to use LLMentor.
               
               11. Governing Law
               These Terms are governed by the laws of the United Kingdom. Any disputes shall be resolved under the exclusive jurisdiction of UK courts.
               
               Questions?
               For any questions, contact info@pharmatools.ai.
               """)
            }
            .padding()
        }
        .navigationTitle("Terms of Use")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
