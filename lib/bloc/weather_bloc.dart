import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:weather_app/data/weather_repository.dart';

import 'weather_state.dart';
import 'weather_event.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository);

  @override
  WeatherState get initialState => WeatherInitial();

  // TODO: format code, DRY
  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    yield WeatherLoading();
    if (event is GetWeather) {
      try {
        final weather = await weatherRepository.fetchWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't fetch weather. Is the device online?");
      }
    } else if (event is GetDetailedWeather) {
      try {
        final weather =
            await weatherRepository.fetchDetailedWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't fetch weather. Is the device online?");
      }
    }
  }
}
