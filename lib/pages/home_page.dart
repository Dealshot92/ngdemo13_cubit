import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:ngdemo13_cubit/bloc/home_cubit.dart';
import 'package:ngdemo13_cubit/bloc/home_state.dart';
import '../models/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.onLoadPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Networking-Cubit"),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) {
          return current is HomePostListState;
        },
        builder: (BuildContext context, HomeState state) {
          if (state is HomeErrorState) {
            return viewOfError(state.errorMessage);
          }
          if (state is HomePostListState) {
            var posts = state.postList;
            return viewOfPostList(posts);
          }
          return viewOfLoading();
        },
      ),

      // Stack(
      //   children: [
      //     RefreshIndicator(
      //       onRefresh: homeCubit.handleRefresh,
      //       child: ListView.builder(
      //         itemCount: homeCubit.posts.length,
      //         itemBuilder: (ctx, index) {
      //           return _itemOfPost(homeCubit.posts[index]);
      //         },
      //       ),
      //     ),
      //     homeCubit.isLoading
      //         ? const Center(
      //             child: CircularProgressIndicator(),
      //           )
      //         : SizedBox.shrink(),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          homeCubit.callCreatePage(context);
        },
      ),
    );
  }

  Widget viewOfError(String err) {
    return Center(
      child: Text("Error occurred $err"),
    );
  }

  Widget viewOfLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget viewOfPostList(List<Post> posts) {
    return Stack(
      children: [
        ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          // controller: scrollController,
          itemCount: homeCubit.posts.length,
          itemBuilder: (ctx, index) {
            return itemOfPost(homeCubit.posts[index]);
          },
        ),
      ],
    );
  }

  Widget itemOfPost(Post post) {
    return Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                homeCubit.callUpdatePage(context, post);
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                homeCubit.onDeletePost();
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(post.body!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.normal)),
              const Divider(),
            ],
          ),
        ));
  }
}
