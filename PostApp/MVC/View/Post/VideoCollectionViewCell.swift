//
//  VideoCollectionViewCell.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit
import AVKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Player
    @IBOutlet weak var playerView: PlayerView!
    
    var video: Video! {
        didSet {
            guard let url = video.url else {
                return
            }
            
            playerView.player = AVPlayer(playerItem: CachingPlayerItem(url: url))
            playerView.playerLayer.videoGravity = .resizeAspectFill
            
            let interval = CMTime(value: 1, timescale: 2)
            timeObserver = playerView.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (time) in
                self.currentTimeLabel.text = time.string
                
            })
            
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidReachEnd(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerView.player!.currentItem)
        }
    }
    
    // MARK: Timer Updates
    @IBOutlet weak var currentTimeLabel: UILabel!
    private var timeObserver: Any?
    @objc
    func videoDidReachEnd(notification: Notification) {
        playerView.player?.seek(to: CMTime.zero)
        playerView.player?.play()
    }
    
    
    // MARK: - Reusability Configurations
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCurrentTime()
    }
    
    class var identifier: String {
        return "VideoCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCurrentTime()
        
        playerView.player?.pause()
        if let timeObserver = self.timeObserver {
            playerView.player?.removeTimeObserver(timeObserver)
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func resetCurrentTime() {
        currentTimeLabel.text = "00:00"
    }
    
    func prepareToClose() {
        playerView.player?.pause()
        playerView.player?.cancelPendingPrerolls()
    }
    
    deinit {
        prepareToClose()
        playerView.removeFromSuperview()
    }
    
    
    // MARK: - Play Functionality
    func play() {
        playerView.player?.play()
    }
    
    func pause() {
        playerView.player?.pause()
    }
}
