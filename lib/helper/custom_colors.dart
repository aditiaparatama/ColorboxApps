import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

Color customColors(String color) {
  switch (color.toLowerCase().replaceAll(" ", "")) {
    case "grey":
      return Colors.grey;
    case "black":
      return colorTextBlack;
    case "brown":
      return Colors.brown;
    case "yellow":
      return Colors.yellow;
    case "gold":
      return const Color(0xFFFFD700);
    case "banana":
      return const Color(0xFFFFE135);
    case "honey":
      return const Color(0xFFF9C901);
    case "lightgrey":
      return const Color(0xFFD3D3D3);
    case "lt.grey":
      return const Color(0xFFD3D3D3);
    case "ash":
      return const Color(0xFF696969);
    case "ochre":
      return const Color(0xFFCC7722);
    case "charcoal":
      return const Color(0xFF36454f);
    case "lime":
      return const Color(0xFF27D507);
    case "darkgrey":
      return const Color(0xFF6B6B6B);
    case "citrus":
      return const Color(0xFF9FB70A);
    case "camel":
      return const Color(0xFFC19A6B);
    //color red
    case "red":
      return Colors.red;
    case "darkred":
      return const Color(0xFF8B0000);
    case "oxbloodred":
      return const Color(0xFF693C40);
    case "maroon":
      return const Color(0xFF640F24);
    case "brickred":
      return const Color(0xFF9E4429);
    case "burgundy":
      return const Color(0xFF5D343E);
    case "ruby":
      return const Color(0xFF9B111E);
    case "redorange":
      return const Color(0xFFDF6038);
    case "rouge":
      return const Color(0xFFAB1239);
    case "vermillion":
      return const Color(0xFFD4463B);
    case "crimson":
      return const Color(0xFF9F2539);
    case "scarlet":
      return const Color(0xFFAD3941);
    case "strawberry":
      return const Color(0xFFE88291);
    case "wine":
      return const Color(0xFF74282D);
    case "cranberry":
      return const Color(0xFFAE5150);
    case "richred":
      return const Color(0xFF931C1A);
    case "redlipstick":
      return const Color(0xFFA42C3C);
    case "rosegold":
      return const Color(0xFFDFB4A7);
    //color green
    case "green":
      return Colors.green;
    case "softgreen":
      return const Color(0xFFCBCD98);
    case "darkgreen":
      return const Color(0xFF384E41);
    case "dustygreen":
      return const Color(0xFF80917E);
    case "jade":
      return const Color(0xFF7B926A);
    case "mint":
      return const Color(0xFFABF0D1);
    case "olive":
      return const Color(0xFF8D8A5C);
    case "army":
      return const Color(0xFF505A35);
    case "peacock":
      return const Color(0xFF49A48C);
    case "emerald":
      return const Color(0xFF409275);
    case "limegreen":
      return const Color(0xFFA6BF4C);
    case "tosca":
      return const Color(0xFF9DD7CA);
    case "turquois":
      return const Color(0xFF6AAEAD);
    case "melon":
      return const Color(0xFFBAD693);
    case "seafoam":
      return const Color(0xFFBCE4E7);
    case "mossgreen":
      return const Color(0xFF83784D);
    case "teal":
      return const Color(0xFF558388);
    case "darkforest":
      return const Color(0xFF596862);
    case "chartreuse":
      return const Color(0xFFB7BE61);
    //color blue
    case "blue":
      return Colors.blue;
    case "darkblue":
      return const Color(0xFF385676);
    case "medblue":
      return const Color(0xFF7391B5);
    case "lt.blue":
      return const Color(0xFFC2D9E7);
    case "lightblue":
      return const Color(0xFFC2D9E7);
    case "spr.lt.blue":
      return const Color(0xFFDFECF4);
    case "sprltblue":
      return const Color(0xFFDFECF4);
    case "electric":
      return const Color(0xFF2663AC);
    case "cobalt":
      return const Color(0xFF0150B5);
    case "blueberry":
      return const Color(0xFF27295D);
    case "skyblue":
      return const Color(0xFF93B9D0);
    case "midnightblue":
      return const Color(0xFF202A45);
    case "navy":
      return const Color(0xFF203757);
    case "denimblue":
      return const Color(0xFF798DA5);
    case "cyan":
      return const Color(0xFF02F8F7);
    case "ocean":
      return const Color(0xFF66C3D0);
    case "iceblue":
      return const Color(0xFFC9E8EA);
    case "powderblue":
      return const Color(0xFF9CB3CF);
    case "babyblue":
      return const Color(0xFFB8C6D2);
    case "ceruleanblue":
      return const Color(0xFFA0B6D1);
    case "tiffanyblue":
      return const Color(0xFF81D8D0);
    case "royalblue":
      return const Color(0xFF3E4486);
    case "aqua":
      return const Color(0xFF71A0AE);
    case "indigo":
      return const Color(0xFF4B516B);
    case "dustyblue":
      return const Color(0xFF869CB0);
    case "tealblue":
      return const Color(0xFF367D7A);
    case "bluepetrol":
      return const Color(0xFF1F617D);
    case "inkblue":
      return const Color(0xFF245267);
    //color white
    case "white":
      return Colors.white;
    case "offwhite":
      return const Color(0xFFFFFFE4);
    case "pearl":
      return const Color(0xFFFADCD8);
    case "wheat":
      return const Color(0xFFE4C5A2);
    case "cream":
      return const Color(0xFFECE3D6);
    case "acru":
      return const Color(0xFFFFE0C7);
    case "natural":
      return const Color(0xFFB18F7A);
    case "snow":
      return const Color(0xFFF1F0EA);
    case "ivory":
      return const Color(0xFFFDFFEF);
    case "creamblush":
      return const Color(0xFFFFBE93);
    case "sand":
      return const Color(0xFFD4A579);
    case "beige":
      return const Color(0xFFD9B992);
    case "bone":
      return const Color(0xFFD9D0BE);
    //color orange
    case "orange":
      return Colors.orange;
    case "brightorange":
      return const Color(0xFFFF9F00);
    case "softorange":
      return const Color(0xFFFFA300);
    case "coral":
      return const Color(0xFFFF6358);
    case "papaya":
      return const Color(0xFFFF9C60);
    case "mango":
      return const Color(0xFFFF8A3F);
    case "persimmon":
      return const Color(0xFFFF705F);
    case "cinnamon":
      return const Color(0xFF743F38);
    case "rust":
      return const Color(0xFFC45321);
    case "apricot":
      return const Color(0xFFFF8B00);
    case "burntorange":
      return const Color(0xFFFF8B00);
    case "neonorange":
      return const Color(0xFFFFAA00);
    //color purple
    case "purple":
      return Colors.purple;
    case "softpurple":
      return const Color(0xFFE1ACD7);
    case "darkpurple":
      return const Color(0xFF601B49);
    case "magenta":
      return const Color(0xFFE62577);
    case "lilac":
      return const Color(0xFFC4ADEA);
    case "dustylilac":
      return const Color(0xFFC1B2C6);
    case "lavender":
      return const Color(0xFFDC94C7);
    case "orchid":
      return const Color(0xFFFFAA00);
    case "violet":
      return const Color(0xFF5B0988);
    case "mauve":
      return const Color(0xFFB67F9C);
    case "plum":
      return const Color(0xFF622360);
    //color pink
    case "pink":
      return Colors.pink;
    case "softpink":
      return const Color(0xFFF5DDDB);
    case "babypink":
      return const Color(0xFFF1DBDF);
    case "fuchsia":
      return const Color(0xFFD4408D);
    case "blush":
      return const Color(0xFFE8C7C8);
    case "dustypink":
      return const Color(0xFFC59492);
    case "neonpink":
      return const Color(0xFFE3337B);
    case "rose":
      return const Color(0xFFF33A6A);
    case "hotpink":
      return const Color(0xFFE33587);
    case "guava":
      return const Color(0xFFD98585);
    case "lt.pink":
      return const Color(0xFFECB3BC);
    case "ltpink":
      return const Color(0xFFECB3BC);
    case "lightpink":
      return const Color(0xFFECB3BC);
    //brown
    case "tan":
      return const Color(0xFFB09678);
    case "khaki":
      return const Color(0xFFB5A990);
    case "taupe":
      return const Color(0xFFA9A099);
    case "copper":
      return const Color(0xFFB47C5D);
    case "bronze":
      return const Color(0xFF8C7049);
    case "chocolate":
      return const Color(0xFF6F3F13);
    case "darkbrown":
      return const Color(0xFFECB3BC);
    case "lightbrown":
      return const Color(0xFFB1967A);
    case "lt.brown":
      return const Color(0xFFB1967A);
    case "ltbrown":
      return const Color(0xFFB1967A);
    case "rustybrown":
      return const Color(0xFF805648);
    case "goldenbrown":
      return const Color(0xFF8B6839);
    case "walnut":
      return const Color(0xFF766A60);
    case "wood":
      return const Color(0xFF976237);
    case "espresso":
      return const Color(0xFF362219);
    case "coffee":
      return const Color(0xFF674D39);
    case "terracotta":
      return const Color(0xFF7D3424);
    case "oatmeal":
      return const Color(0xFFD4CABD);
    case "almond":
      return const Color(0xFF7D3424);
    case "tobacco":
      return const Color(0xFF917357);
    default:
      return Colors.grey;
  }
}
