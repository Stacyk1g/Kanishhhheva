
import 'package:flutter/material.dart';
void main () { runApp(MaterialApp(home:MyApp()));   }



class MyApp extends StatelessWidget {
    Future<String> _fetchData() async { 
       var a= await "HELLO";
       return a;
    }
    
    @override 
    Widget build(BuildContext c) {

    return Scaffold(body:Container(color:Colors.red,width:200,height:200,
    
    child: FutureBuilder<String>(
            future: _fetchData(),  
       builder: (context, snapshot) {
                    return Text('Data: ${snapshot.data}');
                })));
  
}

}