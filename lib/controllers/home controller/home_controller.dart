import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/services/movie_service.dart';

class HomeMovieController extends GetxController {
  final MovieService _movieService = MovieService();

  var trendingMovies = <MovieModel>[].obs;
  var forYouMovies = <MovieModel>[].obs;

  var isLoadingTrending = false.obs;
  var isLoadingForYou = false.obs;

  var errorTrending = ''.obs;
  var errorForYou = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrendingMovies();
    fetchForYouMovies();
  }

  void fetchTrendingMovies() async {
    try {
      isLoadingTrending.value = true;
      errorTrending.value = '';
      trendingMovies.value = await _movieService.getTrendingMovies();
    } catch (e) {
      errorTrending.value = e.toString();
    } finally {
      isLoadingTrending.value = false;
    }
  }

  void fetchForYouMovies() async {
    try {
      isLoadingForYou.value = true;
      errorForYou.value = '';
      forYouMovies.value = await _movieService.getForYouMovies();
    } catch (e) {
      errorForYou.value = e.toString();
    } finally {
      isLoadingForYou.value = false;
    }
  }
}
