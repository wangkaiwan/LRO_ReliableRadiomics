function Texture_feature=extracting_texture_feature(cube)
%extracting textural features from [1,2,3,4] distances and [8,16,32,64,128]
%graylevels.Totally there are 192 features extracted
[Text_feature1,coocMat1]=cooc3d_CT(cube,'distance',[1],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',8);
Text_feature1=Text_feature1;
[Text_feature2,coocMat2]=cooc3d_CT(cube,'distance',[2],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',8);
       Text_feature2=Text_feature2;
[Text_feature3,coocMat3]=cooc3d_CT(cube,'distance',[3],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',8);
       Text_feature3=Text_feature3;
[Text_feature4,coocMat4]=cooc3d_CT(cube,'distance',[4],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',8);
       Text_feature4=Text_feature4;
       
[Text_feature5,coocMat5]=cooc3d_CT(cube,'distance',[1],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',16);
       Text_feature5=Text_feature5;
[Text_feature6,coocMat6]=cooc3d_CT(cube,'distance',[2],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',16);
       Text_feature6=Text_feature6;
[Text_feature7,coocMat7]=cooc3d_CT(cube,'distance',[3],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',16);
       Text_feature7=Text_feature7;
[Text_feature8,coocMat8]=cooc3d_CT(cube,'distance',[4],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',16);
       Text_feature8=Text_feature8;
       
[Text_feature9,coocMat9]=cooc3d_CT(cube,'distance',[1],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',32);
       Text_feature9=Text_feature9;
[Text_feature10,coocMat10]=cooc3d_CT(cube,'distance',[2],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',32);
       Text_feature10=Text_feature10;
[Text_feature11,coocMat11]=cooc3d_CT(cube,'distance',[3],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',32);
       Text_feature11=Text_feature11;
[Text_feature12,coocMat12]=cooc3d_CT(cube,'distance',[4],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',32);
       Text_feature12=Text_feature12;
       
[Text_feature13,coocMat13]=cooc3d_CT(cube,'distance',[1],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',64);
       Text_feature13=Text_feature13;
[Text_feature14,coocMat14]=cooc3d_CT(cube,'distance',[2],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',64);
       Text_feature14=Text_feature14;
[Text_feature15,coocMat15]=cooc3d_CT(cube,'distance',[3],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',64);
       Text_feature15=Text_feature15;
[Text_feature16,coocMat16]=cooc3d_CT(cube,'distance',[4],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',64);
       Text_feature16=Text_feature16;
       
[Text_feature17,coocMat17]=cooc3d_CT(cube,'distance',[1],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',128);
       Text_feature17=Text_feature17;
[Text_feature18,coocMat18]=cooc3d_CT(cube,'distance',[2],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',128);
       Text_feature18=Text_feature18;
[Text_feature19,coocMat19]=cooc3d_CT(cube,'distance',[3],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',128);
       Text_feature19=Text_feature19;
[Text_feature20,coocMat20]=cooc3d_CT(cube,'distance',[4],'direction', [0 1 0; -1 1 0; -1 0 0; -1 -1 0;0 1 -1; 0 0 -1; 0 -1 -1; -1 0 -1; 1 0 -1; -1 1 -1; 1 -1 -1;
           -1 -1 -1; 1 1 -1],'NUMGRAY',128);
       Text_feature20=Text_feature20;
       
Texture_feature=[Text_feature1 Text_feature2 Text_feature3 Text_feature4 Text_feature5 Text_feature6 Text_feature7 Text_feature8...
    Text_feature9 Text_feature10 Text_feature11 Text_feature12 Text_feature13 Text_feature14 Text_feature15 Text_feature16...
    Text_feature17 Text_feature18 Text_feature19 Text_feature20];

       
       
       
       