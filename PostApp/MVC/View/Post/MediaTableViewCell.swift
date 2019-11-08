//
//  MediaTableViewCell.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var medias: [Media] = []
    
    class var identifier: String {
        return "MediaCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
    }
    
    // MARK: - Configure View
    
    func configureCollecrtionView(_ collecitonView: UICollectionView, indexPath: IndexPath, withImage image: Image) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.image = image
        
        return cell
    }
    
    func configureCollectionView(_ collecitonView: UICollectionView, indexPath: IndexPath, withVideo video: Video) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        cell.video = video
        
        return cell
    }
    
    func notifyDismissal() {
        collectionView.visibleCells.forEach {
            if $0.isKind(of: VideoCollectionViewCell.self) {
                ($0 as! VideoCollectionViewCell).prepareToClose()
            }
        }
    }
}

extension MediaTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch medias[indexPath.row] {
        case let video as Video:
            return configureCollectionView(collectionView, indexPath: indexPath, withVideo: video)
        default:
            return configureCollecrtionView(collectionView, indexPath: indexPath, withImage: medias[indexPath.row] as! Image)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: VideoCollectionViewCell.self) {
            (cell as? VideoCollectionViewCell)?.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: VideoCollectionViewCell.self) {
            (cell as? VideoCollectionViewCell)?.pause()
        }
    }
}

extension MediaTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height - 10
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
