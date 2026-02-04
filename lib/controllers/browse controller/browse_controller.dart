import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/services/movie_service.dart';

class BrowseMovieController extends GetxController {
  final MovieService _movieService = MovieService();

  var popularMovies = <MovieModel>[].obs;
  var isLoadingPopular = false.obs;
  var errorPopular = ''.obs;
  var popularPage = 0.obs;
  var popularHasNext = true.obs;

  var nowPlayingMovies = <MovieModel>[].obs;
  var isLoadingNowPlaying = false.obs;
  var errorNowPlaying = ''.obs;
  var nowPlayingPage = 0.obs;
  var nowPlayingHasNext = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularMovies();
    fetchNowPlayingMovies();
  }

  void fetchPopularMovies({bool loadMore = false}) async {
    if (isLoadingPopular.value) return;
    if (loadMore && !popularHasNext.value) return;

    try {
      isLoadingPopular.value = true;
      errorPopular.value = '';

      if (!loadMore) {
        popularPage.value = 0;
        popularMovies.clear();
      }

      final result = await _movieService.getPopularMovies(
          page: popularPage.value, limit: 5);

      final movies = result['movies'] as List<MovieModel>;

      if (loadMore) {
        popularMovies.addAll(movies);
      } else {
        popularMovies.value = movies;
      }
      popularHasNext.value = result['hasNext'] as bool;
      if (popularHasNext.value) {
        popularPage.value++;
      }
    } catch (e) {
      errorPopular.value = e.toString();
    } finally {
      isLoadingPopular.value = false;
    }
  }

  void fetchNowPlayingMovies({bool loadMore = false}) async {
    if (isLoadingNowPlaying.value) return;
    if (loadMore && !nowPlayingHasNext.value) return;

    try {
      isLoadingNowPlaying.value = true;
      errorNowPlaying.value = '';

      if (!loadMore) {
        nowPlayingPage.value = 0;
        nowPlayingMovies.clear();
      }

      final result = await _movieService.getNowPlayingMovies(
        page: nowPlayingPage.value,
        limit: 5,
      );

      final movies = result['movies'] as List<MovieModel>;

      if (loadMore) {
        nowPlayingMovies.addAll(movies);
      } else {
        nowPlayingMovies.value = movies;
      }

      nowPlayingHasNext.value = result['hasNext'] as bool;
      if (nowPlayingHasNext.value) {
        nowPlayingPage.value++;
      }
    } catch (e) {
      errorNowPlaying.value = e.toString();
    } finally {
      isLoadingNowPlaying.value = false;
    }
  }
}
