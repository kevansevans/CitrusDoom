# Citrus Doom

Playable HTML5 Build here: https://kevansevans.github.io/HxDoom/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//About
////////////////////////////////////////////////////////////////////////////////////////////////////
```

Citrus Doom is a Doom engine built on Lime and HxDoom. Currently in way early alpha, as HxDoom is also in alpha. The engine will primarily be tested on C++ anf HTML5, with renderers for Flash and Cairo later down the line to server as examples only.


```
////////////////////////////////////////////////////////////////////////////////////////////////////
//How to build for the experienced
////////////////////////////////////////////////////////////////////////////////////////////////////
```

Citrus will by default use the latest libraries and tools when possible. If Readme is outdated, assume latest unless problems show up.

As of 13DEC2019, HxDoom utilizes the following:
* HaxeDevelop (optional)
* Haxe 4.0.5
* Lime 7.7.0
* haxe-gl-matrix 1.0.1
* HxDoom latest version

Open up CitrusDoom.hxproj in Haxe Develop and hit the compile button

Or install Lime Tools and run ``lime build cpp`` or ``lime build html5``

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//How to build for those new to Haxe
////////////////////////////////////////////////////////////////////////////////////////////////////
```

* Download Haxe from https://haxe.org/
* Install the following haxelibs ``haxelib install`` : ``Lime``, ``haxe-gl-matrix``, ``hxdoom``
* Some targets may require special libraries, C++ will require HXCPP ``haxelib install hxcpp``. Haxe will inform you if a Haxelib is needed.
* Linux users will need to have g++ installed for C++ deployment. Windows will need an install of Microsoft Visual Studio and create the environment variable ``HXCPP_VARS`` and have it point to cl.exe, like so:
	``C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.14.26428\bin\Hostx64\x86``. Paths will differ depending on VS version.
* run the command ``haxelib run lime setup`` and agree to installing the lime command


* If compiling from the terminal, switch directories to the folder containing ``project.xml`` and run the command ``lime build windows`` or ``lime build html5``
* If using HaxeDevlop, navigate to the folder containing ``HxDoom.hxproj`` and open that file, press F5 or click the play button on top.

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
