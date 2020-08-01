import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_images/carousel_images.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Nav(),
    );
  }
}

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _index = 0;
  List<Widget> pages = [
    HomePage(),
    ProductPage(),
    ExchangeRate(),
  ];
  void signOut() async {
    var auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ໜ້າຫຼັກ"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text("ຖ້າຊອກຫາບອກອອກຈາກລະບົບ"),
            ),
            FlatButton(
              child: Text('Log Out'),
              onPressed: () => signOut(),
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.donut_large),
            title: Text('Products'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            title: Text('Rate'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> listImages = [
    'https://www.factroom.ru/wp-content/uploads/2019/04/5-osobennostej-klimata-pitera-o-kotoryh-vy-dolzhny-znat-esli-sobiraetes-syuda-priekhat.jpg',
    'https://cdn.flixbus.de/2018-01/munich-header-d8_0.jpg',
    'https://image.shutterstock.com/image-photo/butterfly-grass-on-meadow-night-260nw-1111729556.jpg',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=1',
    'https://picsum.photos/250?image=4',
  ];
  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          CarouselImages(listImages: listImages, height: 300),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາ',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Container(
            width: 500,
            height: 500,
            child: GridView.count(
              scrollDirection: Axis.vertical,
              childAspectRatio: 1.2,
              crossAxisCount: 2,
              children: List.generate(
                100,
                (index) => Container(
                  width: 200,
                  height: 200,
                  child: Card(
                      margin: EdgeInsets.all(16),
                      elevation: 2,
                      child: Image.network(
                          'https://picsum.photos/250?image=$index',
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      childAspectRatio: 1.2,
      crossAxisCount: 2,
      children: List.generate(
        100,
        (index) => Container(
          width: 200,
          height: 200,
          child: Card(
              margin: EdgeInsets.all(16),
              elevation: 2,
              child: Image.network('https://picsum.photos/250?image=$index',
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}

class ExchangeRate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Baht'),
          trailing: Text('316 kip'),
          subtitle: Text('ຊື້'),
        ),
        ListTile(
          title: Text('Baht'),
          trailing: Text('316 kip'),
          subtitle: Text('ຂາຍ'),
        ),
        ListTile(
          title: Text('Dollar'),
          trailing: Text('9000 kip'),
          subtitle: Text('ຊື້'),
        ),
        ListTile(
          title: Text('Dollar'),
          trailing: Text('9100 kip'),
          subtitle: Text('ຂາຍ'),
        ),
      ],
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  void auth() async {
    final auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Nav(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'ເຂົ້າສູ່ລະບົບ',
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            onChanged: (value) {
              this.email = value;
            },
            decoration: InputDecoration(hintText: 'Email'),
          ),
          SizedBox(
            height: 50,
          ),
          TextFormField(
            onChanged: (value) {
              this.password = value;
            },
            obscureText: true,
            decoration: InputDecoration(hintText: 'password'),
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            onPressed: () {
              auth();
            },
            child: Text('Sign In'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LogOut(),
              ));
            },
            child: Text("register"),
          ),
        ],
      ),
    );
  }
}

class LogOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String email, password;
    void signUp() async {
      final auth = FirebaseAuth.instance;
      await auth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Nav(),
        ));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'ສະໝັກສະມາຊິກ',
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            onChanged: (value) {
              email = value;
            },
            decoration: InputDecoration(hintText: 'Email'),
          ),
          SizedBox(
            height: 50,
          ),
          TextFormField(
            onChanged: (value) {
              password = value;
            },
            obscureText: true,
            decoration: InputDecoration(hintText: 'password'),
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            onPressed: () {
              signUp();
            },
            child: Text('Sign Up'),
          )
        ],
      ),
    );
  }
}
