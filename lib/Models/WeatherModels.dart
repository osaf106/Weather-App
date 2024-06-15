class Weather {
  final String nameOfCity;
  final double temperature;
  final String mainCOntroller;
  //final String weatherDescription ="";
  final double weatherHumidity;
  final double windSpeed;

  Weather(
      {required this.nameOfCity,
      required this.temperature,
      required this.mainCOntroller,
     // required this.weatherDescription,
      required this.weatherHumidity,
        required this.windSpeed
  }
  );

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        nameOfCity: json["name"],
        temperature: json["main"]['temp'].toDouble(),
        mainCOntroller: json["weather"][0]["main"],
      //  weatherDescription: json['weather'][1]['description'],
        weatherHumidity: json['main']['humidity'].toDouble(),
        windSpeed: json['wind']['speed']?.toDouble()
  );
  }
}
