import 'package:flutter/material.dart';
import 'package:ngdemo13_cubit/bloc/update_state.dart';

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
      body: Container(
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
                  updateCubit.onUpdatePost();
                },
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
