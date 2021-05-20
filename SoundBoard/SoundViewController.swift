//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by David Alejo on 5/19/21.
//  Copyright © 2021 David Alejo. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    
    var grabarAudio:AVAudioRecorder?
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
            // DETENER LA GRABACION
            grabarAudio?.stop()
            
            // CAMBIAR TEXTO DE BOTON GRABAR
            grabarButton.setTitle("GRABAR", for: .normal)
        } else {
            // EMPEZAR A GRABAR
            grabarAudio?.record()
            
            // CAMBIAR EL TEXTO DEL BOTON GRABAR A DETENER
            grabarButton.setTitle("DETENER", for: .normal)
        }
    }
    @IBAction func reproducirTapped(_ sender: Any) {
    }
    @IBAction func agregarTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
    }
    
    
    func configurarGrabacion() {
        do {
            // CREANDO SESION DE AUDIO
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // CREANDO DIRECCION PARA EL ARCHIVO DE AUDIO
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            let audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            // IMPRESION DE RUTA DONDE SE GUARDAN LOS ARCHIVOS
            print("******************************")
            print(audioURL)
            print("******************************")
            
            //CREAR OPCIONES PARA EL GRABADOR DE AUDIO
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            // CREAR EL OBJETO DE GRABACION DE AUDIO
            grabarAudio = try AVAudioRecorder(url: audioURL, settings: settings)
            grabarAudio!.prepareToRecord()
            
        } catch let error as NSError {
            print(error)
        }
    }
}
	
