//
//  ContentView.swift
//  Game Timer
//
//  Created by Blake Torres on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countdownTime = 60  // Default countdown time
    @State private var timeRemaining = 60
    @State private var timerRunning = false
    @State private var timer: Timer? = nil
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            VStack {
                // Countdown Label
                Text("\(timeRemaining) seconds")
                    .font(.largeTitle)
                    .padding()

                // Show Start Button and Settings Button only when timer is not running
                if !timerRunning && timeRemaining == countdownTime {
                    Button(action: startTimer) {
                        Text("Start")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    // Show Settings Button
                    NavigationLink(destination: SettingsView(countdownTime: $countdownTime, timeRemaining: $timeRemaining)) {
                        Text("Settings")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                // Show the other buttons only when the timer is running or paused
                if timerRunning || timeRemaining != countdownTime {
                    HStack {
                        // Reset Button (Resets and Restarts the timer)
                        Button(action: resetAndRestartTimer) {
                            Text("Reset")
                                .padding()
                                .background(Color(red: 185/255, green: 0/255, blue: 166/255))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        // Pause/Resume Button
                        if timerRunning {
                            Button(action: pauseTimer) {
                                Text("Pause")
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else if timeRemaining < countdownTime {
                            Button(action: resumeTimer) {
                                Text("Resume")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }

                        // Stop Button (Stops and resets the timer)
                        Button(action: stopTimer) {
                            Text("Stop")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
    }

    // Timer functions
    func startTimer() {
        timerRunning = true
        timeRemaining = countdownTime
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.timerRunning = false
            }
        }
    }

    func resetAndRestartTimer() {
        timer?.invalidate()
        timeRemaining = countdownTime
        timerRunning = true // Set this to true so that pause/resume works as expected
        startTimer()  // Restart the timer immediately after resetting
    }

    func pauseTimer() {
        timer?.invalidate()
        timerRunning = false
    }

    func resumeTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.timerRunning = false
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timeRemaining = countdownTime
        timerRunning = false
    }
}

struct SettingsView: View {
    @Binding var countdownTime: Int
    @Binding var timeRemaining: Int  // New binding to update both
    @Environment(\.dismiss) var dismiss  // To dismiss the view when saving
    @State private var newTime = ""
    @FocusState private var isTextFieldFocused: Bool  // FocusState for TextField

    var body: some View {
        VStack {
            Text("Set New Timer Value")
                .font(.headline)
                .padding()

            TextField("Enter new time in seconds", text: $newTime)
                .keyboardType(.numberPad)
                .padding()
                .border(Color.gray, width: 1)
                .padding()
                .focused($isTextFieldFocused)  // Ensure the text field is focused when tapped

            Button(action: updateTime) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            // Automatically focus on the TextField when the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }

    func updateTime() {
        if let time = Int(newTime), time > 0 {
            countdownTime = time
            timeRemaining = time  // Update both countdownTime and timeRemaining
            dismiss()  // Navigate back to the timer screen
        }
    }
}

