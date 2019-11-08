//
//  VideoPlayWorker.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import AVKit
import Cache

class VideoPlayWorker {
    private var player: AVPlayer!
    
    let diskConfig = DiskConfig(name: "DiskCache")
    let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
    
    lazy var storage: Storage<Data>? = {
        return try? Storage<Data>(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: Data.self))
    }()
    
    // MARK: - Logic
    
    func play(with url: URL) {
        storage?.async.entry(forKey: url.absoluteString, completion: { result in
            let playerItem: CachingPlayerItem
            switch result {
            case .error:
                playerItem = CachingPlayerItem(url: url)
            case .value(let entry):
                playerItem = CachingPlayerItem(data: entry.object, mimeType: "video/mp4", fileExtension: "mp4")
            }
            
            playerItem.delegate = self
            
            self.player = AVPlayer(playerItem: playerItem)
            self.player.automaticallyWaitsToMinimizeStalling = false
            self.player.play()
            
        })
    }
    
}

// MARK: - CachingPlayerItemDelegate
extension VideoPlayWorker: CachingPlayerItemDelegate {
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        storage?.async.setObject(data, forKey: playerItem.url.absoluteString, completion: { _ in })
    }
}
