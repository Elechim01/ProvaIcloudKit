//
//  Nota.swift
//  ProvaIcloudKit
//
//  Created by Michele Manniello on 30/06/21.
//

import Foundation
import CloudKit
class Nota: NSObject{
//    Rifeimento al Recrod che rappresenta la Nota
    var record : CKRecord!
    var titolo : String!
    var testo : String!
//    il database in cui è stata inserita il record/nota
    var database : CKDatabase!
//    la data di creazione del record
    var date: Date
    
    init(record: CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        self.titolo = (record.object(forKey: "titolo") as! String)
        self.testo = (record.object(forKey: "testo") as! String)
        self.date = record.creationDate!
    }
}
