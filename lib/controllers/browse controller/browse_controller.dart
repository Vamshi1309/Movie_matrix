import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/services/movie_service.dart';

class BrowseMovieController extends GetxController {
  final MovieService _movieService = MovieService();

  var popularMovies = <MovieModel>[].obs;
  var nowPlayingMovies = <MovieModel>[].obs;

  var isLoadingPopular = false.obs;
  var isLoadingNowPlaying = false.obs;

  var errorPopular = ''.obs;
  var errorNowPlaying = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularMovies();
    fetchNowPlayingMovies();
  }

  void fetchPopularMovies() async {
    try {
      isLoadingPopular.value = true;
      errorPopular.value = '';
      popularMovies.value = await _movieService.getPopularMovies();
    } catch (e) {
      errorPopular.value = e.toString();
    } finally {
      isLoadingPopular.value = false;
    }
  }

  void fetchNowPlayingMovies() async {
    try {
      isLoadingNowPlaying.value = true;
      errorNowPlaying.value = '';
      nowPlayingMovies.value = await _movieService.getNowPlayingMovies();
    } catch (e) {
      errorNowPlaying.value = e.toString();
    } finally {
      isLoadingNowPlaying.value = false;
    }
  }
}
