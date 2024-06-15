import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Models/WeatherModels.dart';
import 'package:weather_app/Services/WeatherServices.dart';
import 'package:toastification/toastification.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isFocus = false;
  bool alreadyShowErrorMessage = false;
  TextEditingController cityNameController = TextEditingController();

  // api key
  final _weatherService = WeatherServices("bd6016c523124d219fa1ef1cb56f1171");
  Weather? _weather;

  // fetch Weather

  _fetchWeather() async {
    String currentCityName = await _weatherService.getCurrentCity();

    // try weather for city
    try {
      final weather = await _weatherService.getWeather(
          cityNameController.text.toString().isNotEmpty
              ? cityNameController.text.toString().trim()
              : currentCityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      toastification.show(
        // ignore: use_build_context_synchronously
        context: context,
        title: Text(e.toString()),
        autoCloseDuration: const Duration(seconds: 15),
      );
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/images/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
        return "assets/images/cloud.json";
      case 'smoke':
      case 'dust':
        return "assets/images/smoke.json";
      case 'fog':
        return "assets/images/Fog.json";
      case 'rain':
      case 'shower rain':
        return "assets/images/rain.json";
      case 'drizzle':
        return "assets/images/drizzle.json";
      case 'thunder':
        return "assets/images/thunder.json";
      case 'snow':
        return "assets/images/Snow_High.json";
      case "clear":
        return "assets/images/sunny.json";
      default:
        return "assets/images/sunny.json";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _weather?.nameOfCity ?? "Loading city..",
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                      getWeatherAnimation(_weather?.mainCOntroller))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Temperature: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Text(
                    "${_weather?.temperature.round()}°C",
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Weather: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Text(
                    "${_weather?.mainCOntroller}",
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Wind Speed: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Text(
                    _weather?.windSpeed.toString() != null
                        ? "${_weather?.windSpeed.toString()} m/s"
                        : "0.0 m/s",
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Humidity: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Text(
                    _weather?.weatherHumidity.toString() != null
                        ? "${_weather?.weatherHumidity.toString()}%"
                        : "0.0%",
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    isFocus = hasFocus;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Container(
                    width: 250,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isFocus == true
                            ? Border.all(width: 2, color: Colors.black)
                            : Border.all(width: 1)),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: cityNameController,
                      decoration: const InputDecoration(
                        labelText: "Enter City",
                        labelStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            wordSpacing: 3,
                            color: Colors.black45),
                        border: InputBorder.none,
                        prefixIcon:
                            Icon(Icons.location_city, color: Colors.black45),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.hovered) ||
                              states.contains(MaterialState.focused)) {
                            // When pressed, return black color
                            return Colors.black;
                          }
                          // Return default color when not pressed
                          return Colors.black; // Default color
                        },
                      ),
                    ),
                    onPressed: () {
                      if (cityNameController.text.isNotEmpty) {
                        _fetchWeather();
                        FocusScope.of(context).unfocus();
                      } else {
                        toastification.show(
                          // ignore: use_build_context_synchronously
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flat,
                          title: const Text('Empty Text Field'),
                          description: RichText(text: const TextSpan(text: 'Please Fill the text Field First.',style: TextStyle(color: Colors.black))),
                          autoCloseDuration: const Duration(seconds: 3),
                          alignment: Alignment.topRight,
                          direction: TextDirection.ltr,
                          animationDuration: const Duration(milliseconds: 300),
                        );
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const Text(
                      "Find City Weather",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              //SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
            ],
          ),
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}
