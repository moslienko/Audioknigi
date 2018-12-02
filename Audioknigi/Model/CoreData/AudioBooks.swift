//
//  AudioBooks.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 24/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//
import UIKit
import CoreData

struct AudioBooks {
    var id: String //ID книги
    var image: Data //Обложка
    var name: String //Название
    var url: URL //URL адрес книги
    var charter: Int //ID текущей главы
    var time: Float //Время остановки главы

}

/**
 Проверка, сохранена ли уже такая аудиокнига
 - Parameter id: Идентификатор
 - Returns: Результат
 */
func bookAlreadySave(id:String) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    
    do
    {
        let book = try managedContext.fetch(fetchRequest)
        if book.count > 0 {
            return true
        }
    }
    catch
    {
        print(error)
    }
    
    return false
}

/**
 Сохранить аудокнигу
 - Parameter bookInfo: Данные о книги
 - Returns: Статус выполнения операции
 */
func createBook(bookInfo:AudioBooks) -> Bool{
    //Проверка, была ли уже сохранена книга с таким ID
    if !bookAlreadySave(id: bookInfo.id) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Books", in: managedContext)!
        
        let book = NSManagedObject(entity: userEntity, insertInto: managedContext)
        book.setValue(bookInfo.id, forKeyPath: "id")
        book.setValue(bookInfo.image, forKey: "image")
        book.setValue(bookInfo.name, forKey: "name")
        book.setValue(bookInfo.url, forKey: "url")
        
        book.setValue(0, forKey: "charter")
        book.setValue(0, forKey: "time")

        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    return false
}

/**
 Получить аудиокниги из CoreData
 - Returns: Сохраненные аудиокниги
 */
func getMyAudioBooks() -> [AudioBooks]{
    var myBooks = [AudioBooks]()

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return myBooks }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
    
    do {
        let result = try managedContext.fetch(fetchRequest)
        for data in result as! [NSManagedObject] {
            myBooks.append(AudioBooks(
                id: data.value(forKey: "id") as! String,
                image: data.value(forKey: "image") as! Data,
                name: data.value(forKey: "name") as! String,
                url: data.value(forKey: "url") as! URL,
                charter: data.value(forKey: "charter") as! Int,
                time: data.value(forKey: "time") as! Float

            ))
        }
        
        return myBooks
        
    } catch {
        print("Failed")
        return myBooks

    }
}

/**
 Получить аудиокнигу из CoreData
 - Parameter id: Идентификатор книги
 - Returns: Сохраненные аудиокниги
 */
func getAudioBookWithID(_ id:String) -> [AudioBooks]{
    var myBook = [AudioBooks]()
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return myBook }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Books")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do
    {
        let bookInfo = try managedContext.fetch(fetchRequest)
        if bookInfo.count != 0 {
            let objectBook = bookInfo[0] as! NSManagedObject

            myBook.append(AudioBooks(
                id: objectBook.value(forKey: "id") as! String,
                image: objectBook.value(forKey: "image") as! Data,
                name: objectBook.value(forKey: "name") as! String,
                url: objectBook.value(forKey: "url") as! URL,
                charter: objectBook.value(forKey: "charter") as! Int,
                time: objectBook.value(forKey: "time") as! Float
            ))
            return myBook
        }
    }
    catch
    {
        print(error)
        return myBook
    }
    return myBook
}

/**
 Обновить аудокнигу
 - Parameter bookInfo: Данные о книги
 - Returns: Статус выполнения операции
 */
func updateBook(bookInfo:AudioBooks) -> Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Books")
    fetchRequest.predicate = NSPredicate(format: "id = %@", bookInfo.id)
    do
    {
        let book = try managedContext.fetch(fetchRequest)
        
        let objectUpdateBook = book[0] as! NSManagedObject
        objectUpdateBook.setValue(bookInfo.id, forKey: "id")
        objectUpdateBook.setValue(bookInfo.image, forKey: "image")
        objectUpdateBook.setValue(bookInfo.name, forKey: "name")
        objectUpdateBook.setValue(bookInfo.url, forKey: "url")

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
        return false
    }
    
}

/**
 Удалить аудокнигу
 - Parameter id: Идентификатор книги
 - Returns: Статус выполнения операции
 */
func deleteBook(id:String) ->Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    
    do
    {
        let book = try managedContext.fetch(fetchRequest)
        
        let objectToDelete = book[0] as! NSManagedObject
        managedContext.delete(objectToDelete)
        
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
