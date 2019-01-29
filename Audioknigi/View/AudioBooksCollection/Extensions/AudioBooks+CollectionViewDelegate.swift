//
//  AudioBooks+CollectionViewDelegate.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 29/01/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import UIKit

extension AudioBooksCollectionViewController: UICollectionViewDelegate {
   
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) != nil {
            self.performSegue(withIdentifier: "openAudioBook", sender: self)
        }
    }
}
