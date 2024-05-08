import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo13_cubit/bloc/create_cubit.dart';
import 'package:ngdemo13_cubit/bloc/create_state.dart';
import 'package:ngdemo13_cubit/bloc/home_state.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late CreateCubit createCubit;


  backToFinish(){
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    createCubit = BlocProvider.of(context);

    createCubit.stream.listen((state) {
      if (state is CreatedPostState) {
        backToFinish();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Create Post"),
      ),
      body: BlocBuilder<CreateCubit, CreateState>(
        buildWhen: (previous, current){
          return current is HomePostListState;
        },
        builder: (BuildContext context, CreateState state) {
          if (state is CreateErrorState) {
            return viewOfError(state.errorMessage);
          }
          if (state is CreateLoadingState) {
            return viewOfLoading();
          }

          return viewOfNewPost();
        },
      ),
    );
  }


  Widget viewOfNewPost() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: createCubit.titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: createCubit.bodyController,
            decoration: const InputDecoration(hintText: "Body"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            child: MaterialButton(
              color: Colors.blue,
              onPressed: () {
                String title =
                createCubit.titleController.text.toString().trim();
                String body = createCubit.bodyController.text.toString().trim();

                createCubit.onCreatePost();
              },
              child: const Text("Create"),
            ),
          ),
        ],
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

}