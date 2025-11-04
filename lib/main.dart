import 'package:flutter/material.dart';
import './data.dart';
import './product.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

                  if (item is Product) return ProductCard(product: item);
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

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[50],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.shopping_cart, size: 40, color: Colors.orange),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(text: "Price: "),
                      TextSpan(
                        text: "${product.price} ₴",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
      color: Colors.blue[50],
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
