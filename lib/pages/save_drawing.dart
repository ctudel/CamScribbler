import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class SaveDrawing extends StatelessWidget {
  const SaveDrawing({super.key});

  @override
  Widget build(BuildContext context) {
    final Image image = Image.asset(
      'assets/cat.jpeg',
      fit: BoxFit.contain,
    );

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // FIXME: Implement this skeleton to properly store this values
              TextFormField(
                decoration: const InputDecoration(hintText: 'Untitled'),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: image,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Nov 11, 2024'),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                    child: Text(
                      'Discard',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/drawings'),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: const MyNavBar(
          pageIndex: 2,
        ),
      ),
    );
  }
}
