//
//  AudioBooks.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 24/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import SwiftSoup

struct Audio {
    var name: String //Название главы
    var time: String // Продолжительность
}

/**
 Получить HTML содержимое страницы
 - Parameter url: URL страницы
 - Returns: Строка, содержащая код страницы
 */
func getHTMLContent(url:URL) -> String {
    do {
        let html = try String(contentsOf: url, encoding: .utf8)
        return html
    }
    catch {
        return ""
    }
}

/**
 Получить список глав аудио книги
 - Parameter url: URL страницы
 - Returns: Строка, содержащая код страницы
 */
func getCharterBook(url:URL) -> [Audio] {
    var audioList = [Audio]()
    
    do {
        
        let html = getHTMLContent(url: url)
        if html != "" {
            
            let doc: Document = try SwiftSoup.parse(html)
            
            let playlistDiv: Element = try doc.select("div.book_playlist").first()!
            let playlistItem: Elements = try playlistDiv.select("div.book_playlist_item")

            for i in playlistItem.enumerated() {
                audioList.append(Audio(
                    name: try i.element.select("div.book_playlist_item_name").first()!.text(),
                    time: try i.element.select("div.book_playlist_item_time").first()!.text()
                ))
            }
            
            return audioList
        }
        
    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    
    return audioList
}
