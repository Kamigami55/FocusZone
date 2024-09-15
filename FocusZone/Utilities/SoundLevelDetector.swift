import Foundation
import AVFoundation

class SoundLevelDetector: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    @Published var soundLevel: Float = 0.0
    var onExceedThreshold: ((Float) -> Void)?
    
    func startMonitoring() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("temp.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.audioRecorder?.updateMeters()
                self.soundLevel = self.audioRecorder?.averagePower(forChannel: 0) ?? 0.0
//                print("Sound level: \(self.soundLevel)")
                if let onExceedThreshold = self.onExceedThreshold {
                    onExceedThreshold(self.soundLevel)
                }
            }
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        audioRecorder?.stop()
    }
}
