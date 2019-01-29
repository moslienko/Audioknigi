//
//  AudioBooks+CollectionViewDataSource.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 29/01/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import UIKit

extension AudioBooksCollectionViewController: UICollectionViewDataSource {
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AudioBookViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AudioBookViewCell
        let book = self.books[indexPath.row]
        
        cell.bookCover?.image = UIImage(data: book.image)
        cell.bookCover?.shadowAlpha = CGFloat(0.95)
        
        return cell
    }
    
}
