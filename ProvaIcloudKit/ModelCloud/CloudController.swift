//
//  CloudController.swift
//  ProvaIcloudKit
//
//  Created by Michele Manniello on 30/06/21.
//

import Foundation
import CloudKit

protocol CloudControllerDelegate {
    func errorUpdating(error: NSError)
    func modelUpdate()
}


class CloudController: ObservableObject{
    /*
        il CKContainer è il riferimento allo spazio di memoria dedicato all'applicazione. In sostanza è il contenitore di tutti i file pubblici e privati.
        il CKDatabse è l'effettivo riferimento allo spazio pubblico/ privato del container..
    */
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
//    conterra tutti i record recuperati dal container..
  @Published  var noteArray = [Nota]()
    var delegate : CloudControllerDelegate?
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
//    Aggiugere un nuovo record...
    func salvaNota(titolo: String, testo: String){
//        creo il record di tipo nota
        print(container)
        let recordNota = CKRecord(recordType: "Nota")
//        al record setto, titolo e testo ugguali a quelli del parametro della funzione
        recordNota.setValue(testo, forKey: "testo")
        recordNota.setValue(titolo, forKey: "titolo")
        /*
         salvo nel Database Pubblico (la record zone public) il record appena creato
         la funzione è una closure e il corpo stampa un messaggio quando finisce di registrare
         */
            self.publicDB.save(recordNota) { record, error in
            if error != nil{
                print("🤖Errore \(error?.localizedDescription)")
            }else{
                print("🤖Nota salvata con successo ")
            }
        }
    }
//    Metodo che recupera dei dati dall'Icloud..
    func recuperaNote(){
        /*
         Il predicate è il modo in cui i dati devono essere recuperati (ad esempio quelli che hanno un certo valore)
         la CKQuery è il tipo di domanda da fare al databse. In particolare si sta chiedendo tutti i tipi record di tipo "Nota" con nessun tipo di filtro(dato che predicate non è impostato)
         */
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Nota", predicate: predicate)
        
        recuperanote(forQuery: query)
        
        
//        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        let operation = CKQueryOperation(query: query)
//        operation.recordFetchedBlock = { record in
//            DispatchQueue.main.async {
//                self.noteArray.append(Nota(record: record, database: self.publicDB))
//            }
//
//
//        }
//        operation.queryCompletionBlock = {cursor, error in
//            DispatchQueue.main.async {
//                print(self.noteArray.count)
//            }
//        }
//        publicDB.add(operation)
        
        
        
//        la perfomace Query manda in esecuzione la quary. il metodo è una closure che restituisce results (un array di anyObject) o error in caso di query fallita
//        publicDB.perform(query, inZoneWith: nil) { result, error in
////            se l'errore è diverso da nil quindi è stato generato un errore
//            if error != nil{
////                dispatch_async(dispatch_get_main_queue()) {
//                DispatchQueue.global(qos: .userInitiated).async {
//                    DispatchQueue.main.async {
//                        self.delegate?.errorUpdating(error: error! as NSError)
//                        return
//                    }
//                }
//            }else{
//                self.noteArray.removeAll(keepingCapacity: true)
////                se non è stato generato un errore allora itera tutti gli oggetti dell'aray result
//                for record in result!{
//                    /*
//                        crea una nota trasformando il recrod in CKRecord dati che un AnyObject
//                        e inserisce la nota all'interno dell'array di note
//                     */
//                    let nota = Nota(record: record as CKRecord, database: self.publicDB)
//                    DispatchQueue.main.async {
//                        self.noteArray.append(nota)
//                    }
//                    print(self.noteArray)
//
//                }
//            }
////            DispatchQueue.global(qos: .userInitiated).async {
////                DispatchQueue.main.async {
//                    self.delegate?.modelUpdate()
//                    return
////                }
////            }
//
//        }
//    }
    }
    
    private func recuperanote(forQuery query:CKQuery){
        self.publicDB.perform(query,inZoneWith: CKRecordZone.default().zoneID){[weak self] results, error in
            guard let self = self else{return}
            if let error = error {
//                DispatchQueue.main.async {
                    print(error)
//                }
                return
            }
            guard let results = results else { return }
            DispatchQueue.main.async {
                self.noteArray = []
            }
            
            for record in results{
                let nota = Nota(record: record, database: self.privateDB)
                DispatchQueue.main.async {
                    self.noteArray.append(nota)
                }
                
            }
            
            DispatchQueue.main.async {
                print("")
            }
        }
    }
    func EliminaElemento(nota : Nota){
        self.publicDB.delete(withRecordID: nota.record.recordID) { record, error in
            if error != nil{
                print("🤖Errore")
            }else{
                print("🤖Rimozione eseguita con successo ")
            }
        }
    }
    
    
}
