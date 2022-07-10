import 'package:flutter/material.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/states/folders_state.dart';
import 'package:provider/provider.dart';

typedef SliverListBuilder = SliverList Function(BuildContext context);
typedef AllViewBuilder = SliverList Function(BuildContext context);
typedef FolderViewBuilder = SliverList Function(
    BuildContext context, Folder folder);
typedef OnFillFromTemplate = void Function();
typedef OnFoldersClicked = void Function(BuildContext context);

class MyStickyAppBar extends StatelessWidget {
  final Widget? title;
  final bool isFillFromTemplateAvailable;
  final OnFillFromTemplate onFillFromTemplateClicked;
  final OnFoldersClicked onFoldersClicked;
  final AllViewBuilder allViewBuilder;
  final FolderViewBuilder folderViewBuilder;

  const MyStickyAppBar({
    super.key,
    this.title,
    required this.isFillFromTemplateAvailable,
    required this.onFillFromTemplateClicked,
    required this.onFoldersClicked,
    required this.allViewBuilder,
    required this.folderViewBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoldersState>();
    return DefaultTabController(
      initialIndex: 0,
      // One more for the "All" tab
      length: state.folders.length + 1,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                title: title,
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Theme.of(context).primaryColor,
                      tabs: _tabs(state),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: isFillFromTemplateAvailable
                        ? onFillFromTemplateClicked
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder),
                    onPressed: () => onFoldersClicked(context),
                  )
                ],
              ),
            ),
          )
        ],
        body: TabBarView(
          children: [
            _tabView(
              sliverListBuilder: (context) => allViewBuilder(context),
            ),
            for (var folder in state.folders)
              _tabView(
                sliverListBuilder: (context) =>
                    folderViewBuilder(context, folder),
              )
          ],
        ),
      ),
    );
  }

  List<Widget> _tabs(FoldersState state) {
    return [
      const Tab(text: 'All'),
      for (var folder in state.folders) Tab(text: folder.name)
    ];
  }

  Widget _tabView({required SliverListBuilder sliverListBuilder}) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (context) => CustomScrollView(
          slivers: [
            SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
            sliverListBuilder(context)
          ],
        ),
      ),
    );
  }
}
