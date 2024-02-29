//
//  ViewController.swift
//  Player 2.0
//
//  Created by SHAYANUL HAQ SADI on 12/20/23.
//

import UIKit
import AVFoundation


// MARK: player implement #1
//
//class ViewController: UIViewController {
//
//    var player: AVPlayer?
//    var playerLayer: AVPlayerLayer? = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        playerInLayer()
//    }
//
//
//    override func viewWillLayoutSubviews() {
//        playerLayer!.frame = self.view.bounds
//    }
//
//
//    func playerInLayer() {
//        let videoURL = URL(string: "https://bitmovin-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
//
//        let playerItem = AVPlayerItem(url: videoURL!)
//        playerItem.preferredPeakBitRate = 6000000 // player resulation
//
//
//        let player = AVPlayer(playerItem: playerItem)
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer!.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer!)
//        self.player = player
//        player.play()
//        player.rate = 1.0 // player speed
//
//    }
//}

// MARK: player implement #1




// MARK: player implement #2


class ViewController: UIViewController {

    @IBOutlet weak var switchBitrate: UIButton!
    
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Replace with your HLS stream URL
        let streamURL = URL(string: "https://bitmovin-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!

        playerItem = AVPlayerItem(url: streamURL)
        playerItem.preferredPeakBitRate = 6000000
        player = AVPlayer(playerItem: playerItem)

        // Create AVPlayerLayer and add it to your view's layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)

        // Observe the AVPlayerItem's status
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)

        // Observe changes to AVPlayerItem's access log
        playerItem.addObserver(self, forKeyPath: "accessLog", options: .new, context: nil)

        // Start playing the stream
        player.play()
        
        
//        switchBitrate(newBitrate: 20000)
        
        
//        public static let buytton: UIButton = {
//
//            let button = UIButton()
//            button.frame = CGRect(x: view.frame.midX, y: 200, width: 100, height: 100)
//            button.tintColor = .red
//            button.titleLabel?.text = "tap"
//
//            return button
//        } ()
//
//        view.addSubview(buytton)
        switchBitrate.bringSubviewToFront(view)
            
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerLayer.frame = self.view.bounds

    }

    // Observe changes to the AVPlayerItem's status and access log
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if playerItem.status == .readyToPlay {
                // Stream is ready to play
            } else if playerItem.status == .failed {
                // Handle error
                print("Failed to load stream: \(String(describing: playerItem.error))")
            }
        } else if keyPath == "accessLog" {
            if let accessLog = playerItem.accessLog() {
                // Print the available bitrates in the access log
                for event in accessLog.events {
                    print("Available Bitrate: \(event.indicatedBitrate / 1000) kbps")
                }
            }
        }
    }

    // Function to switch bitrate
    func switchBitrate(newBitrate: Double) {
//        print("playerItem  1  ", playerItem.accessLog())
        
        if let accessLog = playerItem.accessLog() {
            
            print("playerItem 2   ", playerItem.accessLog())
            
            
            // Find the variant index for the desired bitrate
            if let variantIndex = accessLog.events.firstIndex(where: { $0.indicatedBitrate == newBitrate * 1000 }) {
                // Pause the player
                print("indicatedBitrate   ", accessLog.events[0].indicatedBitrate)
                
                player.pause()

                // Create a new AVPlayerItem with the selected variant
                let newPlayerItem = AVPlayerItem(url: URL(string: accessLog.events[variantIndex].uri!)!)
                newPlayerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)

                // Replace the current playerItem with the new one
                player.replaceCurrentItem(with: newPlayerItem)

                // Play the stream with the new bitrate
                player.play()
            }
        }
    }
    @IBAction func bitrateChanged(_ sender: Any) {
        switchBitrate(newBitrate: 128)
    }
}



// MARK: player implement #2



