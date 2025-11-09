import 'package:flutter/material.dart';
import './data.dart';
import './post.dart';
import './user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white24),
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/second':(context) => const SecondPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ApiService.loadData().then((data) {
      setState(() {
        items = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                },
                child: const Text("Next"),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  if (item is Post) return PostCard(post: item);
                  if (item is User) return UserCard(user: item);

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title ---
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // --- Body ---
            Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 8),

            // --- Tags ---
            Wrap(
              spacing: 6,
              children: post.tags
                  .map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Colors.lightGreen[100],
              ))
                  .toList(),
            ),

            const SizedBox(height: 10),

            // --- Reactions and Views ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.thumb_up, size: 18, color: Colors.green),
                  const SizedBox(width: 4),
                  Text("${post.likes}"),
                  const SizedBox(width: 12),
                  const Icon(Icons.thumb_down, size: 18, color: Colors.red),
                  const SizedBox(width: 4),
                  Text("${post.dislikes}"),
                ]),
                Row(children: [
                  const Icon(Icons.visibility, size: 18, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Text("${post.views}"),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepOrangeAccent[100],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          child: Text(user.name[0]),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Age: ${user.age}"),
            Text("Email: ${user.email}"),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

///------------------------------------------------------------
enum CheckBoxState { checked, unchecked, indeterminate }

class CheckBoxStateGroup {
  CheckBoxState state;
  List<bool> children;

  CheckBoxStateGroup({required this.children})
      : state = _calculateState(children);

  static CheckBoxState _calculateState(List<bool> children) {
    if (children.every((v) => v == true)) return CheckBoxState.checked;
    if (children.every((v) => v == false)) return CheckBoxState.unchecked;
    return CheckBoxState.indeterminate;
  }

  void toggleGroup() {
    if (state == CheckBoxState.checked) {
      children = List.filled(children.length, false);
    } else {
      children = List.filled(children.length, true);
    }
    state = _calculateState(children);
  }

  void toggleChild(int index, bool value) {
    children[index] = value;
    state = _calculateState(children);
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final group = CheckBoxStateGroup(children: [false, false, false]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: Checkbox(
                value: group.state == CheckBoxState.checked
                    ? true
                    : group.state == CheckBoxState.unchecked
                    ? false
                    : null,
                tristate: true,
                onChanged: (_) {
                  setState(() => group.toggleGroup());
                },
              ),
              title: const Text("Select All"),
            ),

            const Divider(),

            ...List.generate(group.children.length, (i) {
              return CheckboxListTile(
                title: Text("Item ${i + 1}"),
                value: group.children[i],
                onChanged: (val) {
                  setState(() => group.toggleChild(i, val!));
                },
              );
            }),

            const Spacer(),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
