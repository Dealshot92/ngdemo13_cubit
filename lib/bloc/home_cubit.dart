import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo13_cubit/bloc/home_state.dart';
import 'package:ngdemo13_cubit/bloc/update_cubit.dart';
import 'package:ngdemo13_cubit/services/http_service.dart';

import '../models/post_model.dart';
import '../pages/create_page.dart';
import '../pages/update_page.dart';
import 'create_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  bool isLoading = true;
  List<Post> posts = [];

  HomeCubit() : super(HomeInitialState());

  Future<void> onLoadPostListEvent() async {
    emit(HomeLoadingState());

    var response =
        await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());
    if (response != null) {
      var postList = Network.parsePostList(response);
      posts.addAll(postList);
      emit(HomePostListState(posts));
    } else {
      emit(HomeErrorState("Could not fetch posts"));
    }
  }

  Future<void> onDeletePostEvent() async {
    emit(HomeLoadingState());

    var response =
        await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());
    if (response != null) {
      var postList = Network.parsePostList(response);
      posts.addAll(postList);
      emit(HomePostListState(posts));
    } else {
      emit(HomeErrorState("Could not fetch posts"));
    }
  }

  Future callCreatePage(BuildContext context) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => CreateCubit(),
        child: const CreatePage(),
      );
    }));

    if (result) {
      // loadPosts();
    }
  }

  Future callUpdatePage(BuildContext context, Post post) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => UpdateCubit(),
        child: UpdatePage(post: post),
      );
    }));

    if (result) {
      // _loadPosts();
    }
  }

  Future<void> handleRefresh() async {
    // _loadPosts();
  }
}
