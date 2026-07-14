import 'dart:developer';

import 'package:checkmate/features/news/presentation/bloc/article/article_bloc.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),

      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (_, state) {
          if (state is ArticleLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ArticleError) {
            log(state.error!.message!);
            return Center(child: Icon(Icons.error));
          }
          if (state is ArticleLoaded) {
            return ListView.builder(
              itemCount: state.articles!.length,

              itemBuilder: (context, index) {
                final article = state.articles![index];

                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.article_outlined),
                  ),
                  title: Text(article.title),
                  subtitle: Text(
                    article.description ?? 'No description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
