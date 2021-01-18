import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String image;
  final String route;

  MenuItem({@required this.title, @required this.image, @required this.route});

  void selectMenu(BuildContext context) {
    if (route == '/kasir')
      Navigator.pushNamedAndRemoveUntil(context, '/kasir', (route) => false);
    else
      Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: InkWell(
            onTap: () => selectMenu(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
