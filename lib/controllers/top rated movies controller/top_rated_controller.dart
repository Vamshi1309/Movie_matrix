import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/services/movie_service.dart';

class TopRatedController extends GetxController {
  final MovieService _movieService = MovieService();

  var topRatedMovies = <MovieModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var topRatedPage = 0.obs;
  var topRatedHasNext = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopRatedMovies();
  }

  void fetchTopRatedMovies({bool loadMore = false}) async {
    if (isLoading.value) return;
    if (loadMore && !topRatedHasNext.value) return;

    try {
      isLoading.value = true;
      error.value = '';

      if (!loadMore) {
        topRatedPage.value = 0;
        topRatedMovies.clear();
      }

      final result = await _movieService.getTopRatedMovies(
        page: topRatedPage.value,
        limit: 10,
      );

      final movies = result['movies'] as List<MovieModel>;

      if (loadMore) {
        topRatedMovies.addAll(movies);
      } else {
        topRatedMovies.value = movies;
      }

      topRatedHasNext.value = result['hasNext'] as bool;
      if (topRatedHasNext.value) {
        topRatedPage.value++;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
