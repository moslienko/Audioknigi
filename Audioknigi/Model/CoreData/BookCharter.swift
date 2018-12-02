//
//  BookCharter.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 01/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Charter {
    var number:Int //Номер главы
    var bookID:String //ID книги
    var name: String //Название главы
    var duration: String // Продолжительность
    var url: URL //Ссылка на файл
}

/**
 Сохранить главы аудиокниги в Core Data
 - Parameter charterData: Информация о главе
 - Returns: Статус выполнения операции
 */
func saveCharters(charterData:Charter) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Charters", in: managedContext)!
    
        let book = NSManagedObject(entity: userEntity, insertInto: managedContext)
        book.setValue(charterData.bookID, forKeyPath: "bookID")
        book.setValue(charterData.duration, forKeyPath: "duration")
        book.setValue(charterData.name, forKeyPath: "name")
        book.setValue(charterData.number, forKeyPath: "number")
        book.setValue(charterData.url, forKeyPath: "url")
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
}


/**
 Получить главы аудиокниги из CoreData
 - Parameter id: Идентификатор книги
 - Returns: Главы
 */
func getChartersForBookID(_ id:String) -> [Charter]{
    var chartersList = [Charter]()
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return chartersList }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Charters")
    fetchRequest.predicate = NSPredicate(format: "bookID = %@", id)
    let sort = NSSortDescriptor(key: "number", ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    do
    {
        let charters = try managedContext.fetch(fetchRequest)
            for charter in charters as! [NSManagedObject] {
                chartersList.append(Charter(
                    number: charter.value(forKey: "number") as! Int,
                    bookID: charter.value(forKey: "bookID") as! String,
                    name: charter.value(forKey: "name") as! String,
                    duration: charter.value(forKey: "duration") as! String,
                    url: charter.value(forKey: "url") as! URL
                ))
            }

            return chartersList
        }
    catch
    {
        print(error)
        return chartersList
    }
    return chartersList
}


/**
 Удалить все главы аудиокниги
 - Parameter id: Идентификатор книги
 - Returns: Статус выполнения операции
 */
func deleteChartersForBookID(_ id:String) ->Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Charters")
    fetchRequest.predicate = NSPredicate(format: "bookID = %@", id)
    
    do
    {
        let charters = try managedContext.fetch(fetchRequest)
        for charter in charters as! [NSManagedObject] {
            managedContext.delete(charter)
        }
        
        do{
            try managedContext.save()
            return true
        }
        catch
        {
            print(error)
            return false
        }
        
    }
    catch
    {
        print(error)
    }
    
    return false
}
