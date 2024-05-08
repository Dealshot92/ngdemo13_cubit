import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:ngdemo13_cubit/bloc/update_state.dart';

import '../bloc/home_state.dart';
import '../bloc/update_cubit.dart';
import '../models/post_model.dart';

class UpdatePage extends StatefulWidget {
  final Post post;

  const UpdatePage({super.key, required this.post});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late UpdateCubit updateCubit;

  backToFinish() {
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateCubit = BlocProvider.of(context);
    updateCubit.titleController.text = widget.post.title!;
    updateCubit.bodyController.text = widget.post.body!;

    updateCubit.stream.listen((state) {
      if (state is UpdatedPostState) {
        backToFinish();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Update Post"),
      ),
      body: BlocBuilder<UpdateCubit, UpdateState>(
        buildWhen: (previous, current){
          return current is HomePostListState;
        },
        builder: (BuildContext context, UpdateState state) {
          if (state is UpdateErrorState) {
            return viewOfError(state.errorMessage);
          }
          if (state is UpdateLoadingState) {
            return viewOfLoading();
          }

          return viewOfUpdatePost();
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

  Widget viewOfUpdatePost(){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            child: TextField(
              controller: updateCubit.titleController,
              decoration: const InputDecoration(hintText: "Title"),
            ),
          ),
          Container(
            child: TextField(
              controller: updateCubit.bodyController,
              decoration: const InputDecoration(hintText: "Body"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            child: MaterialButton(
              color: Colors.blue,
              onPressed: () {
                updateCubit.onUpdatePost(context, widget.post);
              },
              child: const Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}
