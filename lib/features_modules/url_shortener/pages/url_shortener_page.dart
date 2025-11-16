import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/url_shortener_cubit.dart';
import '../cubits/url_shortener_state.dart';
import '../services/concretes/url_shortener_service.dart';
import '../utils/url_helper.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/url_input_section.dart';
import '../widgets/url_list_item.dart';

class UrlShortenerPage extends StatefulWidget {
  const UrlShortenerPage({super.key});

  @override
  State<UrlShortenerPage> createState() => _UrlShortenerPageState();
}

class _UrlShortenerPageState extends State<UrlShortenerPage> {
  final TextEditingController _urlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _handleShortenUrl(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final normalizedUrl = UrlHelper.normalizeUrl(_urlController.text.trim());
      context.read<UrlShortenerCubit>().shortenUrl(normalizedUrl);
      _urlController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UrlShortenerCubit(UrlShortenerService()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'URL Shortener',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<UrlShortenerCubit, UrlShortenerState>(
          listener: (context, state) {
            if (state is UrlShortenerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is UrlShortenerSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('URL shortened successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is UrlShortenerLoading;

            return Column(
              children: [
                UrlInputSection(
                  controller: _urlController,
                  formKey: _formKey,
                  onSubmit: () => _handleShortenUrl(context),
                  isLoading: isLoading,
                ),
                Expanded(
                  child: state.shortenedUrls.isEmpty
                      ? const EmptyStateWidget(
                          icon: Icons.link_off,
                          title: 'No shortened URLs yet',
                          subtitle: 'Enter a URL above to get started',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: state.shortenedUrls.length,
                          itemBuilder: (context, index) {
                            return UrlListItem(
                              shortenedUrl: state.shortenedUrls[index],
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
