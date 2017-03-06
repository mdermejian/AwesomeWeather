//
//  ForecastViewController.swift
//  AwesomeWeather
//
//  Created by Marc Dermejian on 03/03/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit
import AlamofireImage

class ForecastViewController: UIViewController {

	private var forecast: Forecast? {
		didSet {
			updateUI()
		}
	}
	
	//implicitly unwrapped optionals. Will prompt development with error if not set
	var forecastManager: ForecastManager!
	var location: Location!
	
	// MARK: - IBOutlets

	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var forecastImageView: UIImageView!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var windspeedLabel: UILabel!
	
	
	// MARK: - View controller lifecycle

	override func viewDidLoad() {
        super.viewDidLoad()

		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.view.backgroundColor = UIColor.clear
		
		locationLabel.text = location.areaName
		
		forecastManager.getForecast(forLocation: location.areaName!) { (success, _forecast) in
			
			guard success == true, let _forecast = _forecast else {
				return
			}
			
			self.forecast = _forecast
		}
    }

	// MARK: UI Updates

	func updateUI() {
		guard let forecast = forecast else { return }

		let placeholderImage = UIImage(named: Images.PlaceholderWeatherIconImageName)
		if let url = forecast.weatherIconURL {
			forecastImageView.af_setImage(withURL: url,
			                            placeholderImage: placeholderImage,
			                            filter: nil,
			                            progress: nil,
			                            progressQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
			                            imageTransition: .crossDissolve(0.3),
			                            runImageTransitionIfCached: false,
			                            completion: nil)
		}else {
			forecastImageView.image = placeholderImage
		}

		descriptionLabel.text = forecast.shortDescription
		temperatureLabel.text = "\(forecast.tempC!)°C"
		windspeedLabel.text = "\(forecast.windspeed!)Kph"

		UIView.animate(withDuration: 0.7) {
			self.descriptionLabel.alpha = 1.0
			self.temperatureLabel.alpha = 1.0
			self.windspeedLabel.alpha = 1.0
		}
	}

}
