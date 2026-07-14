import 'dart:developer';

import 'package:checkmate/features/news/presentation/bloc/article/article_bloc.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),

      floatingActionButton: Row(
        children: [
          SizedBox(width: 20),
          FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () async {
              final result = await Supabase.instance.client
                  .from('otp_verifications')
                  .select()
                  .eq('phone', '9188129607')
                  .eq('otp', '123456')
                  .eq('verified', false)
                  .gt('expires_at', DateTime.now().toIso8601String());

              if (result.isNotEmpty) {
                log(result.toString());
              }
              await Supabase.instance.client
                  .from('otp_verifications')
                  .update({'verified': true})
                  .eq('id', result.first['id']);
            },
          ),
          SizedBox(width: 20),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              // List logs = await Supabase.instance.client.from('notes').select();
              // log('lsgs :$logs');
              final otp = '123456';

              // varify
              await Supabase.instance.client
                  .from('otp_verifications')
                  .delete()
                  .eq('phone', '9188129607');

              log('Old OTP removed');
              // final nwes = DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
              await Supabase.instance.client.from('otp_verifications').insert({
                'phone': '9188129607',
                'otp': otp,
                'expires_at': DateTime.now()
                    .add(const Duration(minutes: 5))
                    .toIso8601String(),
                'verified': false,
              });

              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text('add note'),
                  contentPadding: EdgeInsetsGeometry.all(20),
                  children: [
                    TextFormField(
                      onFieldSubmitted: (value) async {
                        await Supabase.instance.client.from('test').insert({
                          'test_clmn': value,
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (_, state) {
          if (state is ArticleLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ArticleError) {
            log(state.error?.toString() ?? 'Unknown error');
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
