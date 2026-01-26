import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/services/movie_service.dart';

class TopRatedController extends GetxController {
  final MovieService _movieService = MovieService();

  var topRatedMovies = <MovieModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopRatedMovies();
  }

  void fetchTopRatedMovies() async {
    try {
      isLoading.value = true;
      error.value = '';
      final movies = await _movieService.getTopRatedMovies();
      topRatedMovies.value = movies;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
