//
//  ContentView.swift
//  ProvaIcloudKit
//
//  Created by Michele Manniello on 30/06/21.
//

import SwiftUI
import CoreData
import CloudKit

struct ContentView: View,CloudControllerDelegate {
    
    
    func errorUpdating(error: NSError) {
        mesaggio = error.localizedDescription
        alert.toggle()
    }

    func modelUpdate() {
        print("update")
//        cloudCtr.recuperaNote()
    }
    
   @StateObject var cloudCtr = CloudController()
//    init() {
//        cloudCtr.delegate = self
//        cloudCtr.recuperaNote()
//    }
//    Creo un alert
    @State var alert : Bool = false
    @State var mesaggio : String = ""
   @State var timer = Timer()
    var body: some View {
        
            VStack {
                HStack {
                    Text("prova Icloud")
                    Text("\(cloudCtr.noteArray.count)")
                    Button(action: {
                        cloudCtr.salvaNota(titolo: "Ciao", testo: "come va ")
                        cloudCtr.noteArray = []
                        RecuperaElementi()
                    }, label: {
                        Text("Aggiungi nota")
                    })
                }
                .padding()
                Button(action: {
                    cloudCtr.noteArray = []
                    RecuperaElementi()
                }, label: {
                    Text("Legi")
                })
                .padding()
                    List(cloudCtr.noteArray, id: \.self){ nota in
//                        HStack{
                            Text("\(nota.testo), \(nota.titolo)")
                            Button {
                                self.cloudCtr.EliminaElemento(nota: nota)
                                cloudCtr.noteArray = []
                                cloudCtr.recuperaNote()
                            } label: {
                                Text("elimina")
                            }

//                        }
                        
//                    .onDelete { index in
//
//                        self.cloudCtr.noteArray.remove(atOffsets: index)
//
//                    }
                }
                
            }
            .alert(isPresented: $alert, content: {
                Alert(title: Text("Errore Cloudkit"), message: Text("\(mesaggio)"), dismissButton: .default(Text("Chiudi")))
        })
            .onAppear{
                RecuperaElementi()
                
                
            }
    }
    
    func RecuperaElementi(){
        var secondi = 0.0
//        DispatchQueue.global(qos: .background).async {
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { temp in
//                    while(true){
                self.cloudCtr.recuperaNote()
//                    secondi += 0.01
//                    }
//                    }
//        }
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
