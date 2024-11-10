import SwiftUI
import AVFoundation
import Shared

public extension CameraFeedView {

    struct ViewShowOptions {

        let showSettingAlert: Binding<Bool>
        let showTimerOptions: Bool
        let showModeOptions: Bool

        public init(showSettingAlert: Binding<Bool>, showTimerOptions: Bool, showModeOptions: Bool) {
            self.showSettingAlert = showSettingAlert
            self.showTimerOptions = showTimerOptions
            self.showModeOptions = showModeOptions
        }

    }

    struct ContentView: View {

        @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State private var timeRemaining: Int = 0
        @State private var isTimerRunning: Bool = false

        let currentMode: Binding<CameraMode>
        let currentTimer: Binding<TimerMode>
        let isLoading: Bool
        let isRecording: Bool
        let isFlashOn: Bool
        let session: AVCaptureSession
        let showOptions: CameraFeedView.ViewShowOptions
        let onEvent: (Event) -> Void

        var cameraFeedPreview: CameraFeedPreview

        init(
            session: AVCaptureSession,
            isLoading: Bool,
            currentMode: Binding<CameraMode>,
            currentTimer: Binding<TimerMode>,
            isRecording: Bool,
            isFlashOn: Bool,
            showOptions: CameraFeedView.ViewShowOptions,
            onEvent: @escaping (Event) -> Void
        ) {
            self.session = session
            self.currentMode = currentMode
            self.currentTimer = currentTimer
            self.isLoading = isLoading
            self.isRecording = isRecording
            self.isFlashOn = isFlashOn
            self.showOptions = showOptions
            self.onEvent = onEvent

            cameraFeedPreview = CameraFeedPreview(session: session)
        }

        public var body: some View {
            contentView
                .onAppear {
                    onEvent(.didAppear)
                }
                .alert(isPresented: showOptions.showSettingAlert) {
                    Alert(
                        title: Text("Warning"),
                        message: Text("Application doesn't have all permissions to use camera and microphone, please change privacy settings."),
                        dismissButton: .default(Text("Go to settings"), action: {
                            onEvent(.openSettings)
                        })
                    )
                }
        }

        private var contentView: some View {
            GeometryReader { geometry in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    cameraFeedPreview
                        .ignoresSafeArea(.all)
                    VStack(spacing: .zero) {
                        topButtons
                            .padding(.horizontal, 24)
                            .padding(.horizontal, 16)
                        Spacer()
                        modeSelectors
                        HStack {
                            CameraOptionsButton {
                                onEvent(.showModeOptions)
                            }
                            .padding(.leading, 24)
                            .padding(.trailing, 16)
                            Spacer()
                            SnapButton(
                                currentMode: currentMode,
                                isLoading: isLoading,
                                isRecording: isRecording
                            ) { mode in
                                if currentTimer.wrappedValue.value > 0 && !isRecording {
                                    timeRemaining = currentTimer.wrappedValue.value
                                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                    isTimerRunning = true
                                } else {
                                    onEvent(.tappedOnSnapButton(mode))
                                }
                            }
                            .disabled(isTimerRunning)
                            .padding(.horizontal, 16)
                            Spacer()
                            CameraSwitchButton {
                                onEvent(.switchCamera)
                            }
                            .padding(.leading, 16)
                            .padding(.trailing, 24)
                        }
                        .frame(height: 104)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.6))
                    }

                    if timeRemaining > 0 {
                        countdownTimer
                    }
                }
                .onReceive(timer) { time in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                        if timeRemaining <= 0 {
                            onEvent(.tappedOnSnapButton(currentMode.wrappedValue))
                            timer.upstream.connect().cancel()
                            isTimerRunning = false
                        }
                    }
                }
            }
        }

        private var countdownTimer: some View {
            Text("\(timeRemaining)")
                .font(.system(size: 100, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(
                    Circle()
                        .foregroundColor(Color.black.opacity(0.4))
                        .frame(width: 150, height: 150)
                )
        }

        private var modeSelectors: some View {
            VStack {
                if showOptions.showTimerOptions {
                    ModeSelector(
                        currentMode: currentTimer.wrappedValue.toModeSelectorItem,
                        modes: TimerMode.allModeSelectorCases,
                        isDisabled: false
                    ) {
                        onEvent(.changeTimerOption(.init(rawValue: $0.id)))
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    .transition(.slide)
                }
                if showOptions.showModeOptions {
                    ModeSelector(
                        currentMode: currentMode.wrappedValue.toModeSelectorItem,
                        modes: CameraMode.allModeSelectorCases,
                        isDisabled: isRecording
                    ) {
                        onEvent(.switchModeOption($0.isPhoto ? .photo : .video(false)))
                    }
                    .padding(.bottom, 16)
                    .transition(.slide)
                }
            }
            .disabled(isTimerRunning)
        }

        private var topButtons: some View {
            HStack {
                FlashSwitchButton(isOn: isFlashOn) {
                    onEvent(.switchFlash)
                }
                Spacer()
                timerButton
            }
        }

        private var timerButton: some View {
            HStack {
                Text(currentTimer.wrappedValue.title)
                    .font(.caption)
                    .padding(.trailing, 8)
                TimerButton {
                    onEvent(.showTimerOptions)
                }
            }
        }

    }

}
