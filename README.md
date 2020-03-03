# Citrus Doom

Playable HTML5 Build here: https://kevansevans.github.io/HxDoom/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//About
////////////////////////////////////////////////////////////////////////////////////////////////////
```

Citrus Doom is a Doom engine built on Lime and HxDoom. Currently in way alpha, as HxDoom is also in alpha.


```
////////////////////////////////////////////////////////////////////////////////////////////////////
//How to build
////////////////////////////////////////////////////////////////////////////////////////////////////
```

Citrus Doom will by default use the latest libraries and tools when possible.

As of 13DEC2019, HxDoom utilizes the following:
* HaxeDevelop
* Haxe 4.0.3
* Lime 7.7.0
* HxDoom latest

Other libraries will be dependant on the target you are focusing on, such as HXCPP, HXJAVA, HXCS. 
The Haxe compiler will inform you if these libraries are needed.

Instructions:
* Download Haxe from https://haxe.org/
	
* use the commands ``haxelib install lime`` and ``haxelib install hxdoom``
* run the command ``haxelib run lime setup`` and agree to installing the lime command
* if compiling from the terminal, switch directories to the folder containing ``project.xml`` and run the command ``lime build windows`` or ``lime build html5``
* if using HaxeDevlop, navigate to the folder containing ``HxDoom.hxproj`` and open that file, press F5 or click the play button on top.

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//How to contribute
////////////////////////////////////////////////////////////////////////////////////////////////////
```

Contributions to Citrus Doom are not currently accepted, but will be in the future when I feel the engine is up to snuff. If and when this
happens, it is encouraged, but not mandatory, that you have knowledge of the following:

* Understanding of Doom modding
* Understanding of Haxe and it's tools
* Understanding of WebGL


```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Haxe port by kevansevans
////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                         ...,,,,,,,,..                     
//                  ./&&%(/**,,,,,,,,,**/%&*               
//              .//,,,,,,,,,,,,,,,,,,,,,,,,/&&/            
//           ./&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*&&,         
//         .#%*,*#/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#&,       
//        ,@#,,(*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/&(      
//      .%@*,/#,,,,,,,,,,,,,,,,*((/,,,,,,,,,,,,,,,,,,,##     
//     .&&/,*/,,,,,,,,,,,,,/#/,,,,,,,,,,,,,,,,,,,,,,,,,#&.   
//     %##,*%,,,,,,,,,,,,#(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%#   
//    ,%(/,#*,,,,,,,,,*#(,,,,,,,,,,,,,,,,,,,*/#%#%,,,,,,*&.  
//    (/#*,#,,,,,,,,,*%,,,,,,,,,,,,,,*/#%#*.    (*,,,,,,,((  
//    &*%**(,,,,,,,,/#,,,,,,,,,,*(&%(%.       /#,,,,,,,,,*%. 
//    &/%**(,,,,,,,/#,,,,,,,*/&%/%(  ,*     ,#/(#,,,,,,,,,&. 
//    ((##*%*******%*******#&&/*(@&**#,    *. (#,,,,,,,,,,&, 
//    .%/&/%/******%*****(&*.%**(@&*/&      *&/,,,,,,,,,,,&. 
//     /%/&/%******%****(#.  ,#****#(     /%**(*,,,,,,,,,*%. 
//      .%(&/%/****%/**/&(/    /%%/      .,#%*%*,,,,,,,,,#*  
//        ,%####***/%**#/   ....      /%/*****%*,,,,,,,,/&.  
//          .(%%/*/%*#*         .(#*.%/*****%,,,,,,,,*&*   
//              #%&@@%#%%#/*/%...#*    *%****(/,,,,,,,*&,    
//             /#*****/(%***#*...#,    (%***/%,,,,,,,(&.     
//          .%%*,,,,*#%&%%%,......*.,&/**/(,,,,,,/%,       
//       (&(((((##(/%%,,,,*%,....../##&/*(#*,,,,*&(.         
//         /%(/***/&/,,,,,,/(......*(#/,,,*(&(,            
//             .,(&,,,,,,,,*%    .*/(*,.                 
//              (#,,,,,**,,,/*    ..,#(#&&&/                 
//             *(,,,,*&/*,,,,%.  #*,,,,***&/                 
//           .#(,,,*%#(%******%(.%*******(&.                 
//           %/,,,/@(//##*******##*******&%#   
////////////////////////////////////////////////////////////////////////////////////////////////////
```
