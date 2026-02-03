import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/services/search_service.dart';

class MovieController extends GetxController {
  final SearchService _service = SearchService();

  final isLoading = true.obs;
  final error = ''.obs;
  final data = Rxn<MovieModel>();

  void OnInit(){
    
  }

  Future<void> getMovie(String movieName) async {
    try {
      isLoading.value = true;
      error.value = "";

      final movie = await _service.getMovieByTitle(movieName);

      data.value = movie?.data;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
