import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recollar_frontend/bloc/my_objects_bloc.dart';
import 'package:recollar_frontend/events/my_objects_event.dart';
import 'package:recollar_frontend/general_widgets/button_primary_cpnt.dart';
import 'package:recollar_frontend/general_widgets/loading_cpnt.dart';
import 'package:recollar_frontend/general_widgets/text_field_primary_cpnt.dart';
import 'package:recollar_frontend/general_widgets/text_subtitle_cpnt.dart';
import 'package:recollar_frontend/general_widgets/text_title_cpnt.dart';
import 'package:recollar_frontend/models/object_request.dart';
import 'package:recollar_frontend/state/my_objects_state.dart';
import 'package:recollar_frontend/util/configuration.dart';


import 'package:recollar_frontend/models/object.dart';
import 'package:recollar_frontend/screens/my_collections/widgets/no_image.dart';

class ObjectForm extends StatefulWidget{
  @override
  _ObjectFormState createState() => _ObjectFormState();
}

class _ObjectFormState extends State<ObjectForm>{
  TextEditingController nameController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController priceController=TextEditingController();

  int idCollection = 0;
  String image = "abc";
  int status = 0;
  int objectStatus = 1;

  XFile ?_imagePublication;
  Size sizeP=const Size(1,1);
  bool firstBuild=false;

  @override  Widget build(BuildContext context) {
    sizeP=MediaQuery.of(context).size;
    return BlocBuilder<MyObjectsBloc,MyObjectsState>(
        builder: (context,state) {
          if(state is MyObjectsOk){
            WidgetsBinding.instance!.addPostFrameCallback((_){
              Navigator.pop(context);
            });
          }

          return WillPopScope(
            onWillPop: ()async{

              context.read<MyObjectsBloc>().add(MyObjectsInit());
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: color1, //change your color here
                ),
                leadingWidth: 30,
                title: TextTitleCPNT( colorText: colorWhite, text: widget.edit?"Editar colección":"Nueva collección", weight: FontWeight.w600),
                backgroundColor: color2,
                actions: [
                  ButtonPrimaryCPNT(onPressed: (){
                    if(widget.edit){
                      _edit(context,state.object!);

                    }else{
                      _add(context);
                    }
                  }, size: Size(sizeP.width*0.1,10), colorBg: color2, colorText: color1, text: "aceptar", elevation: 0)
                ],
                elevation: 1,
              ),
              body: Stack(
                children: [
                  Scaffold(
                    backgroundColor: colorGray,

                    body: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top:70),
                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                _openGallery();
                              },
                              child: ClipRRect(

                                child:
                                _imagePublication!=null?Image(image:FileImage(File(_imagePublication!.path)),fit:BoxFit.cover,width: sizeP.width*0.7,height:  sizeP.width*0.7,):
                                widget.edit&&state.object!=null?Image.network("http://"+(dotenv.env['API_URL'] ?? "")+"/image/"+state.object!.image,headers: {"Authorization":"Bearer ${state.object!.token}"},fit:BoxFit.cover,width: sizeP.width*0.7,height:  sizeP.width*0.7,):NoImage(size:Size(sizeP.width*0.7,sizeP.width*0.7)),
                                borderRadius:  BorderRadius.circular(10),

                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                            child:
                            TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Nombre del objeto", weight: FontWeight.w600)

                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){},icon: null, textType: TextInputType.text, obscureText: false, controller: nameController, colorBorder: colorWhite, size: Size(sizeP.width*0.9,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                            child:
                            TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Descripción", weight: FontWeight.w600)

                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){},icon: null, textType: TextInputType.text, obscureText: false, controller: descriptionController, colorBorder: colorWhite, size: Size(sizeP.width*0.9,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeP.width*0.05),
                            child:
                            TextSubtitleCPNT( colorText: color2.withOpacity(0.7), text: "Precio", weight: FontWeight.w600)

                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            TextFieldPrimaryCPNT(maxLength: 50,onChanged: (text){},icon: null, textType: TextInputType.number, obscureText: false, controller: priceController, colorBorder: colorWhite, size: Size(sizeP.width*0.9,50), colorBg: colorWhite, colorText: color2, hintText: ""),
                          ],
                        ),
                        const SizedBox(height: 100,),
                      ],
                    ),
                  ),
                  state is MyObjectsFormLoading?LoadingCPNT(size: sizeP):Container()
                ],
              ),
            ),
          );
        }
    );
  }
  _openGallery() async {
    var imagePicker = ImagePicker();
    var picture = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picture != null) {
      setState(() {
        _imagePublication=picture;
      });
    }
    //this.setState({});
  }

  _add(BuildContext context){
    int idObject = 1;
    int idCollection = 1;
    int objectStatus = 1;

    ObjectRequest objectRequest = ObjectRequest(idObject,idCollection,nameController.text,descriptionController.text,objectStatus,double.parse(priceController.text));

    context.read<MyObjectsBloc>().add(MyObjectsAdd(objectRequest,_imagePublication??XFile("")));
  }
  _edit(BuildContext context,Object object){
    ObjectRequest objectRequest = ObjectRequest(object.idObject,object.idCollection,nameController.text,descriptionController.text,objectStatus,double.parse(priceController.text));

    context.read<MyObjectsBloc>().add(MyObjectsUpdate(object,_imagePublication??XFile("")));
  }
}