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
    
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    
    var contador = 0
    var tiempo = Timer()
    @IBOutlet weak var temporizador: UILabel!
    
    @IBOutlet weak var volumen: UISlider!
    
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
            // DETENER LA GRABACION
            grabarAudio?.stop()
            
            // CAMBIAR TEXTO DE BOTON GRABAR
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            agregarButton.isEnabled = true
            
            tiempo.invalidate()
            		
        } else {
            // EMPEZAR A GRABAR
            grabarAudio?.record()
            
            // CAMBIAR EL TEXTO DEL BOTON GRABAR A DETENER
            grabarButton.setTitle("DETENER", for: .normal)
            
            reproducirButton.isEnabled = false
            
            contador = 0
            tiempo.invalidate()
            tiempo = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(contadorDeTiempo), userInfo: nil, repeats: true)
           
        }
    }
    @IBAction func reproducirTapped(_ sender: Any) {
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            Volumen()
            reproducirAudio!.play()
            print("Reproduciendo")
        }catch {}
    }
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        grabacion.temporizador = temporizador.text
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        agregarButton.isEnabled = false
    }
    
    @objc func contadorDeTiempo() {
        contador += 1
        let seg:String = String(format: "%02d",(contador % 3600) % 60)
        let min:String = String(format: "%02d",(contador % 3600) / 60)
        let hrs:String = String(format: "%02d",contador / 3600)
        temporizador.text = "\(hrs):\(min):\(seg)"
    }
    
    @IBAction func configurarAudio(_ sender: Any) {
        Volumen()
    }
    
    func Volumen(){
        let selectedValue = Float(volumen.value)
        reproducirAudio?.volume = selectedValue
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
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            // IMPRESION DE RUTA DONDE SE GUARDAN LOS ARCHIVOS
            print("******************************")
            print(audioURL!)
            print("******************************")
            
            //CREAR OPCIONES PARA EL GRABADOR DE AUDIO
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            // CREAR EL OBJETO DE GRABACION DE AUDIO
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
            
        } catch let error as NSError {
            print(error)
        }
    }
    
}
	
