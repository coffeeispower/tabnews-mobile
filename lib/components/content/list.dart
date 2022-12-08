import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tabnews_flutter/client/client.dart';

import '../../client/entities/content.dart';
import 'item.dart';

class ContentList extends StatefulWidget {
  final Strategy strategy;
  const ContentList({super.key, required this.strategy});

  @override
  // ignore: library_private_types_in_public_api
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  static const _pageSize = 30;
  final PagingController<int, Content> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) =>
      // Don't worry about displaying progress or error indicators on screen; the
      // package takes care of that. If you want to customize them, use the
      // [PagedChildBuilderDelegate] properties.
      PagedListView<int, Content>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Content>(
          itemBuilder: (context, item, index) => ContentListItem(
            index: index + 1,
            content: item,
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await TabNewsClient.listContents(pageKey, _pageSize, widget.strategy);
      final isLastPage = newItems.length < _pageSize;
      if (!mounted) {
        return;
      }
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }
}
