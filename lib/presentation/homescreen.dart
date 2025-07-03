import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/bottom_sheet.dart';
import 'package:todo_app/presentation/todo_popup.dart';
import 'package:todo_app/utils/app_strings.dart';
import 'package:todo_app/utils/asset_utils.dart';
import '../view_model/todo_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      if (mounted) {
        final todoViewModel = Provider.of<TodoViewModel>(context);
        todoViewModel.getRequest();
      }
      _isInit = false;
    }
  }

  int? userID;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoViewModel = Provider.of<TodoViewModel>(context);
    return ChangeNotifierProvider(
      create: (context) => TodoViewModel(),
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black.withOpacity(0.08),
          backgroundColor: Colors.black12,
          title: Center(
            child: Text(
              kYourTodos,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
            ),
          ),
        ),
        body: todoViewModel.todos.isEmpty
            ? Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage(AssetUtils.empty)),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final user = todoViewModel.todos[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              shape: DiamondCutCardShape(),
                              color: Colors.purpleAccent.shade100.withValues(
                                alpha: 0.4,
                              ),
                              child: SizedBox(
                                height: 120,
                                child: ListTile(
                                  title: Text(user.title),
                                  style: ListTileStyle.list,
                                  subtitle: Text(
                                    "${user.description.split("").take(15).join(" ")}...",
                                  ),
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        content: const Text(
                                          "Delete this item?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              kCancel,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                todoViewModel.deleteRequest(
                                                  user.id,
                                                );
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(kNoteDeleted),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              kDelete,
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return ChangeNotifierProvider(
                                          create: (context) =>
                                              TodoViewModel(todoId: user.id),
                                          child: MyBottomSheet(
                                            initialHeading: user.title,
                                            initialNote: user.description,
                                            todoId: user.id,
                                            todoViewModel: todoViewModel,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: todoViewModel.todos.length,
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return MyBottomSheet(todoViewModel: todoViewModel);
              },
            );
          },
          isExtended: true,
          shape: OvalBorder(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class DiamondCutCardShape extends ShapeBorder {
  final double borderRadius;

  const DiamondCutCardShape({this.borderRadius = 16.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final double halfWidth = rect.width / 2.5;
    final double oneThirdHeight = rect.height / 3;
    final double controlPointOffset = borderRadius * 0.55; // Approximation for circular arc

    path.moveTo(rect.left + borderRadius, rect.top);
    path.lineTo(rect.left + halfWidth - borderRadius, rect.top);
    path.quadraticBezierTo(
      rect.left + halfWidth,
      rect.top,
      rect.left + halfWidth,
      rect.top + borderRadius*2.4,
    );
    path.lineTo(
      rect.left + halfWidth,
      rect.top + oneThirdHeight - borderRadius,
    );
    path.quadraticBezierTo(
      rect.left + halfWidth,
      rect.top + oneThirdHeight,
      rect.left + halfWidth+ borderRadius,
      rect.top + oneThirdHeight,
    );

    path.lineTo(rect.right - borderRadius, rect.top + oneThirdHeight);
    path.quadraticBezierTo(
      rect.right,
      rect.top + oneThirdHeight,
      rect.right,
      rect.top + oneThirdHeight + borderRadius,
    );

    path.lineTo(rect.right, rect.bottom - borderRadius);
    path.quadraticBezierTo(
      rect.right,
      rect.bottom,
      rect.right - borderRadius,
      rect.bottom,
    );

    path.lineTo(rect.left + borderRadius, rect.bottom);
    path.quadraticBezierTo(
      rect.left,
      rect.bottom,
      rect.left,
      rect.bottom - borderRadius,
    );

    path.lineTo(rect.left, rect.top + borderRadius);
    path.quadraticBezierTo(
      rect.left,
      rect.top,
      rect.left + borderRadius,
      rect.top,
    );

    path.close();
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
