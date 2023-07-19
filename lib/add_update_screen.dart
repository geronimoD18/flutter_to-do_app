import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/model.dart';

class AddUpdateTask extends StatefulWidget{
  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {

  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async{
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context){
    final titleController = TextEditingController();
    final descController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add/Update Task",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _fromKey,
              child: Column(children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Note Title",
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter a title";
                    }
                    return null;
                  },
                ),),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 5,
                    controller: descController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Note Description",
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter a description";
                      }
                      return null;
                    },
                  ),),
              ],),
            ),
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: (){
                        if(_fromKey.currentState!.validate()){
                          dbHelper!.insert(TodoModel(
                            title: titleController.text,
                            desc: descController.text,
                            dateandtime: DateFormat('yMd')
                                .add_jm()
                                .format(DateTime.now())
                                .toString()));
                          
                          Navigator.push(context, MaterialPageRoute(builder:
                          (context)=> HomeScreen()));
                          titleController.clear();
                          descController.clear();
                          //confirmacion de registro agregado
                          print("Data added");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     blurRadius: 5,
                          //     spreadRadius: 1,
                          //   ),
                          // ],
                        ),
                        child: Text("Save", style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(10),

                    child: InkWell(
                      onTap: (){
                        setState(() {
                          titleController.clear();
                          descController.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     blurRadius: 5,
                          //     spreadRadius: 1,
                          //   ),
                          // ],
                        ),
                        child: Text("Clear",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],),
            ),
          ],),
        ),
      ),
    );
  }
}