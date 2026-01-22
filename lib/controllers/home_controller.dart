import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/services/movie_service.dart';

class HomeController extends GetxController {
  final MovieService _movieService = MovieService();

  var trendingMovies = <MovieModel>[].obs;
  var topRatedMovies = <MovieModel>[].obs;
  var forYouMovies = <MovieModel>[].obs;

  // Loading state
  var isLoadingTrending = false.obs;
  var isLoadingTopRated = false.obs;
  var isLoadingForYou = false.obs;

  // Error state
  var errorTrending = ''.obs;
  var errorTopRated = ''.obs;
  var errorForYou = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllMovies();
  }

  void fetchAllMovies() async {
    fetchTrendingMovies();
    fetchTopRatedMovies();
    fetchForYouMovies();
  }

  void fetchTrendingMovies() async {
    try {
      isLoadingTrending.value = true;
      errorTrending.value = '';
      final movies = await _movieService.getTrendingMovies();
      trendingMovies.value = movies;
    } catch (e) {
      errorTrending.value = e.toString();
    } finally {
      isLoadingTrending.value = false;
    }
  }

  void fetchTopRatedMovies() async {
    try {
      isLoadingTopRated.value = true;
      errorTopRated.value = '';
      final movies = await _movieService.getTopRatedMovies();
      topRatedMovies.value = movies;
    } catch (e) {
      errorTopRated.value = e.toString();
    } finally {
      isLoadingTopRated.value = false;
    }
  }

  void fetchForYouMovies() async {
    try {
      isLoadingForYou.value = true;
      errorForYou.value = '';
      final movies = await _movieService.getForYouMovies();
      forYouMovies.value = movies;
    } catch (e) {
      errorForYou.value = e.toString();
    } finally {
      isLoadingForYou.value = false;
    }
  }
}
