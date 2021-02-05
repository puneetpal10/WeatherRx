//
//  ViewController.swift
//  GoodWeather
//
//  Created by Mohammad Azam on 3/6/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel! 
    
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit).asObservable().map{ self.cityNameTextField.text }.subscribe(onNext: { city in
            if let city = city{
                if city.isEmpty{
                    self.displayWeather(nil)
                }else{
                    self.fetchWeather(by: city)
                }
            }
            
        }).disposed(by: disposeBag)
        
//
//        self.cityNameTextField.rx.value.subscribe(onNext: { city in
//            if let city = city{
//                if city.isEmpty{
//                    self.displayWeather(nil)
//                }else{
//                    self.fetchWeather(by: city)
//                }
//            }
//        }).disposed(by: disposeBag)
    }

    
    private func displayWeather(_ weather: Weather?){
        if let weather = weather{
            self.temperatureLabel.text = "\(weather.temp)"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        }else{
            self.temperatureLabel.text = "🍄"
            self.humidityLabel.text = "@"

        }
        
    }
    private func fetchWeather(by city: String){
        
        guard let city = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city) else {
            return
        }
        
        let resourse = Resourse<WeatherResult>(url: url)
     
        
        /*
        let search =  URLRequest.load(recourse: resourse).catchErrorJustReturn(WeatherResult.empty).observeOn(MainScheduler.instance).asDriver(onErrorJustReturn: WeatherResult.empty)*/
        
        let search = URLRequest.load(resourse: resourse).observeOn(MainScheduler.instance).retry(3)
            .catchError{ error in
            print(error.localizedDescription)
            return Observable.just(WeatherResult.empty)
        }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map{
            "\($0.main.temp)🌝"
        }.drive(self.temperatureLabel.rx.text).disposed(by: disposeBag)
        
        
        search.map{ " \($0.main.humidity)🧜‍♂️"}.drive( self.humidityLabel.rx.text).disposed(by: disposeBag)
        
        
        
//      let search =  URLRequest.load(recourse: resourse).catchErrorJustReturn(WeatherResult.empty).observeOn(MainScheduler.instance)
//
//        search.map{
//            "\($0!.main.temp)🌝"
//        }.bind(to: self.temperatureLabel.rx.text).disposed(by: disposeBag)
//
//
//        search.map{ " \($0!.main.humidity)🧜‍♂️"}.bind(to:  self.humidityLabel.rx.text).disposed(by: disposeBag)
        
//        URLRequest.load(recourse: resourse).catchErrorJustReturn(WeatherResult.empty).observeOn(MainScheduler.instance)
//            .subscribe(onNext: {
//            result in
//
//            if let result = result{
//                let weather = result.main
//                self.displayWeather(weather)
//            }
//        }).disposed(by: disposeBag)
    }
}

